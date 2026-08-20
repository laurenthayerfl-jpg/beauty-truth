[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$credentialTarget = 'TheBeautyTruth.WordPress.REST'
$siteUrlVariable = 'BEAUTY_TRUTH_WORDPRESS_SITE_URL'
$usernameVariable = 'BEAUTY_TRUTH_WORDPRESS_USERNAME'

function ConvertFrom-MaskedInput {
    param(
        [Parameter(Mandatory = $true)]
        [Security.SecureString] $Value
    )

    $valuePointer = [IntPtr]::Zero
    try {
        $valuePointer = [Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($Value)
        return [Runtime.InteropServices.Marshal]::PtrToStringUni($valuePointer)
    }
    finally {
        if ($valuePointer -ne [IntPtr]::Zero) {
            [Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($valuePointer)
        }
    }
}

if (-not ('BeautyTruth.NativeCredential' -as [type])) {
    Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

namespace BeautyTruth
{
    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    public struct NativeCredentialData
    {
        public UInt32 Flags;
        public UInt32 Type;
        public string TargetName;
        public string Comment;
        public System.Runtime.InteropServices.ComTypes.FILETIME LastWritten;
        public UInt32 CredentialBlobSize;
        public IntPtr CredentialBlob;
        public UInt32 Persist;
        public UInt32 AttributeCount;
        public IntPtr Attributes;
        public string TargetAlias;
        public string UserName;
    }

    public static class NativeCredential
    {
        [DllImport("advapi32.dll", EntryPoint = "CredWriteW", CharSet = CharSet.Unicode, SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool CredWrite(ref NativeCredentialData credential, UInt32 flags);
    }
}
'@
}

Write-Host 'This setup collects the WordPress site URL, username, and Application Password.'
Write-Host 'All three prompts are masked and none of the values will be printed or written to this project.'
Write-Host ''

$siteUrlInput = Read-Host -Prompt 'Paste the WordPress site URL, then press Enter' -AsSecureString
$usernameInput = Read-Host -Prompt 'Paste the WordPress username, then press Enter' -AsSecureString
$applicationPassword = Read-Host -Prompt 'Paste the WordPress Application Password, then press Enter' -AsSecureString

if ($siteUrlInput.Length -eq 0) {
    $siteUrlInput.Dispose()
    $usernameInput.Dispose()
    $applicationPassword.Dispose()
    throw 'No site URL was entered. Nothing was changed.'
}

if ($usernameInput.Length -eq 0) {
    $siteUrlInput.Dispose()
    $usernameInput.Dispose()
    $applicationPassword.Dispose()
    throw 'No username was entered. Nothing was changed.'
}

if ($applicationPassword.Length -eq 0) {
    $siteUrlInput.Dispose()
    $usernameInput.Dispose()
    $applicationPassword.Dispose()
    throw 'No application password was entered. Nothing was changed.'
}

$siteUrl = ConvertFrom-MaskedInput -Value $siteUrlInput
$wordpressUsername = ConvertFrom-MaskedInput -Value $usernameInput
$siteUrlInput.Dispose()
$usernameInput.Dispose()

$siteUri = $null
if (-not [Uri]::TryCreate($siteUrl, [UriKind]::Absolute, [ref] $siteUri)) {
    $applicationPassword.Dispose()
    throw 'The WordPress site URL is not a valid absolute URL. Nothing was changed.'
}

if (
    $siteUri.Scheme -ne 'https' -or
    -not $siteUri.IsDefaultPort -or
    -not [string]::IsNullOrEmpty($siteUri.UserInfo) -or
    ($siteUri.AbsolutePath -ne '/' -and -not [string]::IsNullOrEmpty($siteUri.AbsolutePath)) -or
    -not [string]::IsNullOrEmpty($siteUri.Query) -or
    -not [string]::IsNullOrEmpty($siteUri.Fragment)
) {
    $applicationPassword.Dispose()
    throw 'For safety, enter the HTTPS site origin only, with no path, query, fragment, embedded username, or custom port.'
}

$siteUrl = $siteUri.GetLeftPart([UriPartial]::Authority)

$passwordPointer = [IntPtr]::Zero
$passwordBytes = $null
$pinnedPassword = $null

try {
    $passwordPointer = [Runtime.InteropServices.Marshal]::SecureStringToCoTaskMemUnicode($applicationPassword)
    $passwordBytes = New-Object byte[] ($applicationPassword.Length * 2)
    [Runtime.InteropServices.Marshal]::Copy($passwordPointer, $passwordBytes, 0, $passwordBytes.Length)
    $pinnedPassword = [Runtime.InteropServices.GCHandle]::Alloc(
        $passwordBytes,
        [Runtime.InteropServices.GCHandleType]::Pinned
    )

    $credential = New-Object BeautyTruth.NativeCredentialData
    $credential.Flags = 0
    $credential.Type = 1
    $credential.TargetName = $credentialTarget
    $credential.Comment = 'The Beauty Truth WordPress REST API application password'
    $credential.CredentialBlobSize = $passwordBytes.Length
    $credential.CredentialBlob = $pinnedPassword.AddrOfPinnedObject()
    $credential.Persist = 2
    $credential.AttributeCount = 0
    $credential.Attributes = [IntPtr]::Zero
    $credential.TargetAlias = $null
    $credential.UserName = $wordpressUsername

    if (-not [BeautyTruth.NativeCredential]::CredWrite([ref] $credential, 0)) {
        $errorCode = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
        throw "Windows Credential Manager could not store the credential (Windows error $errorCode)."
    }

    [Environment]::SetEnvironmentVariable($siteUrlVariable, $siteUrl, 'User')
    [Environment]::SetEnvironmentVariable($usernameVariable, $wordpressUsername, 'User')
}
finally {
    if ($null -ne $pinnedPassword -and $pinnedPassword.IsAllocated) {
        $pinnedPassword.Free()
    }

    if ($null -ne $passwordBytes) {
        [Array]::Clear($passwordBytes, 0, $passwordBytes.Length)
    }

    if ($passwordPointer -ne [IntPtr]::Zero) {
        [Runtime.InteropServices.Marshal]::ZeroFreeCoTaskMemUnicode($passwordPointer)
    }

    $applicationPassword.Dispose()
}

Write-Host ''
Write-Host 'WordPress REST credentials are configured.'
Write-Host "Credential vault entry: $credentialTarget"
Write-Host "Site URL environment variable: $siteUrlVariable"
Write-Host "Username environment variable: $usernameVariable"
Write-Host 'None of the three values were printed or written to the project.'
