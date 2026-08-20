[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$credentialTarget = 'TheBeautyTruth.WordPress.REST'
$siteUrlVariable = 'BEAUTY_TRUTH_WORDPRESS_SITE_URL'
$usernameVariable = 'BEAUTY_TRUTH_WORDPRESS_USERNAME'

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
        [DllImport("advapi32.dll", EntryPoint = "CredReadW", CharSet = CharSet.Unicode, SetLastError = true)]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool CredRead(string target, UInt32 type, UInt32 flags, out IntPtr credentialPointer);

        [DllImport("advapi32.dll", SetLastError = false)]
        public static extern void CredFree(IntPtr credentialPointer);
    }
}
'@
}

$siteUrl = [Environment]::GetEnvironmentVariable($siteUrlVariable, 'User')
$configuredUsername = [Environment]::GetEnvironmentVariable($usernameVariable, 'User')

if ([string]::IsNullOrWhiteSpace($siteUrl)) {
    throw "The user environment variable $siteUrlVariable is not configured. Run the setup script first."
}

if ([string]::IsNullOrWhiteSpace($configuredUsername)) {
    throw "The user environment variable $usernameVariable is not configured. Run the setup script first."
}

$siteUri = $null
if (-not [Uri]::TryCreate($siteUrl, [UriKind]::Absolute, [ref] $siteUri)) {
    throw "The configured WordPress site URL is not a valid absolute URL."
}

if (
    $siteUri.Scheme -ne 'https' -or
    -not $siteUri.IsDefaultPort -or
    -not [string]::IsNullOrEmpty($siteUri.UserInfo) -or
    ($siteUri.AbsolutePath -ne '/' -and -not [string]::IsNullOrEmpty($siteUri.AbsolutePath)) -or
    -not [string]::IsNullOrEmpty($siteUri.Query) -or
    -not [string]::IsNullOrEmpty($siteUri.Fragment)
) {
    throw 'Safety check failed: the configured site must be an HTTPS origin with no path, query, fragment, embedded username, or custom port.'
}

$credentialPointer = [IntPtr]::Zero
$passwordBytes = $null
$applicationPassword = $null
$curlConfig = $null
$curlOutput = $null
$curlError = $null
$curlProcess = $null

function ConvertTo-CurlConfigValue {
    param(
        [Parameter(Mandatory = $true)]
        [string] $Value
    )

    if ($Value.Contains("`r") -or $Value.Contains("`n")) {
        throw 'Safety check failed: a credential value contains a line break.'
    }

    return $Value.Replace('\', '\\').Replace('"', '\"')
}

try {
    if (-not [BeautyTruth.NativeCredential]::CredRead($credentialTarget, 1, 0, [ref] $credentialPointer)) {
        $errorCode = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
        throw "The Windows Credential Manager entry '$credentialTarget' could not be read (Windows error $errorCode). Run the setup script first."
    }

    $credential = [Runtime.InteropServices.Marshal]::PtrToStructure(
        $credentialPointer,
        [type] [BeautyTruth.NativeCredentialData]
    )

    if ($credential.UserName -ne $configuredUsername) {
        throw 'Safety check failed: the username environment variable does not match the username in Windows Credential Manager.'
    }

    $passwordBytes = New-Object byte[] $credential.CredentialBlobSize
    [Runtime.InteropServices.Marshal]::Copy(
        $credential.CredentialBlob,
        $passwordBytes,
        0,
        $passwordBytes.Length
    )
    $applicationPassword = [Text.Encoding]::Unicode.GetString($passwordBytes)

    $endpointBuilder = [UriBuilder]::new($siteUri)
    $endpointBuilder.Path = '/wp-json/wp/v2/users/me'
    $endpointBuilder.Query = 'context=edit&_fields=id,roles'
    $endpoint = $endpointBuilder.Uri

    $curlCommand = Get-Command 'curl.exe' -ErrorAction Stop
    $escapedEndpoint = ConvertTo-CurlConfigValue -Value $endpoint.AbsoluteUri
    $escapedUsername = ConvertTo-CurlConfigValue -Value $configuredUsername
    $escapedPassword = ConvertTo-CurlConfigValue -Value $applicationPassword

    $curlConfig = @(
        "url = `"$escapedEndpoint`""
        'request = "GET"'
        "user = `"$escapedUsername`:$escapedPassword`""
        'basic'
        'header = "Accept: application/json"'
        'user-agent = "WP-REST-ReadOnly-Auth-Test/1.1"'
        'max-redirs = 0'
        'connect-timeout = 15'
        'max-time = 30'
        'silent'
        'show-error'
        'write-out = "\n__BT_HTTP_STATUS__:%{http_code}\n"'
    ) -join "`n"

    $processInfo = [Diagnostics.ProcessStartInfo]::new()
    $processInfo.FileName = $curlCommand.Source
    $processInfo.Arguments = '--config -'
    $processInfo.UseShellExecute = $false
    $processInfo.CreateNoWindow = $true
    $processInfo.RedirectStandardInput = $true
    $processInfo.RedirectStandardOutput = $true
    $processInfo.RedirectStandardError = $true

    $curlProcess = [Diagnostics.Process]::new()
    $curlProcess.StartInfo = $processInfo
    if (-not $curlProcess.Start()) {
        throw 'The built-in Windows curl client could not be started.'
    }

    $curlProcess.StandardInput.Write($curlConfig)
    $curlProcess.StandardInput.Close()
    $curlConfig = $null
    $escapedPassword = $null

    $curlOutput = $curlProcess.StandardOutput.ReadToEnd()
    $curlError = $curlProcess.StandardError.ReadToEnd()
    $curlProcess.WaitForExit()

    if ($curlProcess.ExitCode -ne 0) {
        throw "The read-only HTTPS request could not be completed (curl exit code $($curlProcess.ExitCode)). No content was changed."
    }

    $statusMarker = "`n__BT_HTTP_STATUS__:"
    $statusMarkerIndex = $curlOutput.LastIndexOf($statusMarker, [StringComparison]::Ordinal)
    if ($statusMarkerIndex -lt 0) {
        throw 'The read-only HTTPS response did not contain the expected status marker.'
    }

    $responseBody = $curlOutput.Substring(0, $statusMarkerIndex)
    $statusText = $curlOutput.Substring($statusMarkerIndex + $statusMarker.Length).Trim()
    $statusCode = 0
    if (-not [int]::TryParse($statusText, [ref] $statusCode)) {
        throw 'The read-only HTTPS response contained an invalid status code.'
    }

    if ($statusCode -ge 300 -and $statusCode -lt 400) {
        throw "Authentication test stopped safely because the endpoint returned an HTTP redirect ($statusCode). Credentials were not forwarded."
    }

    if ($statusCode -lt 200 -or $statusCode -ge 300) {
        $safeApiCode = $null
        try {
            $errorPayload = $responseBody | ConvertFrom-Json
            $safeApiCode = $errorPayload.code
        }
        catch {
            $safeApiCode = $null
        }

        $apiSuffix = if ([string]::IsNullOrWhiteSpace($safeApiCode)) { '' } else { "; WordPress code: $safeApiCode" }
        throw "Read-only WordPress authentication test failed (HTTP $statusCode$apiSuffix). No content was changed."
    }

    $authenticatedUser = $responseBody | ConvertFrom-Json

    if ($null -eq $authenticatedUser.id) {
        throw 'The server returned HTTP 200, but the authenticated WordPress user response was incomplete.'
    }

    if ($null -eq $authenticatedUser.roles -or 'editor' -notin $authenticatedUser.roles) {
        throw 'Authentication succeeded, but the dedicated WordPress account does not report the expected Editor role.'
    }

    Write-Host 'READ-ONLY WORDPRESS AUTHENTICATION TEST: PASS'
    Write-Host 'HTTP method: GET'
    Write-Host 'HTTP result: 200 OK'
    Write-Host 'Dedicated Editor role: confirmed'
    Write-Host 'No WordPress content was created, edited, deleted, published, or scheduled.'
}
finally {
    if ($null -ne $curlProcess) {
        $curlProcess.Dispose()
    }

    if ($null -ne $passwordBytes) {
        [Array]::Clear($passwordBytes, 0, $passwordBytes.Length)
    }

    $curlConfig = $null
    $curlOutput = $null
    $curlError = $null
    $applicationPassword = $null

    if ($credentialPointer -ne [IntPtr]::Zero) {
        [BeautyTruth.NativeCredential]::CredFree($credentialPointer)
    }
}
