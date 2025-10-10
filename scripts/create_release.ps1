param(
  [Parameter(Mandatory=$true)]
  [string]$Tag,
  [Parameter(Mandatory=$true)]
  [string]$ApkPath,
  [string]$Title = "Release $Tag",
  [string]$NotesFile = "RELEASE_NOTES.md"
)

# Usage: .\create_release.ps1 -Tag v1.0-release -ApkPath "build\app\outputs\flutter-apk\app-release.apk"

if (-not (Test-Path $ApkPath)) {
  Write-Error "APK not found at $ApkPath"
  exit 1
}

if (-not (Test-Path $NotesFile)) {
  $notes = "Release $Tag"
} else {
  $notes = Get-Content $NotesFile -Raw
}

# Prefer gh CLI if available
$ghPath = (Get-Command gh -ErrorAction SilentlyContinue).Source
if ($ghPath) {
  Write-Output "Creating release with gh CLI..."
  gh release create $Tag $ApkPath --title "$Title" --notes "$notes"
  exit $LASTEXITCODE
}

# Fallback to GitHub API using GITHUB_TOKEN
if (-not $env:GITHUB_TOKEN) {
  Write-Error "gh CLI not found and GITHUB_TOKEN is not set. Please authenticate 'gh' or set GITHUB_TOKEN environment variable."
  exit 1
}

$repo = (git remote get-url origin) -replace '\.git$','' -replace '^.*github.com[:/]',''
$apiUrl = "https://api.github.com/repos/$repo/releases"

$body = @{ tag_name = $Tag; name = $Title; body = $notes } | ConvertTo-Json
$headers = @{ Authorization = "token $env:GITHUB_TOKEN"; "User-Agent" = "PowerShell" }

Write-Output "Creating release via GitHub API..."
$response = Invoke-RestMethod -Method Post -Uri $apiUrl -Headers $headers -Body $body -ContentType 'application/json'

# Upload asset
$assetName = Split-Path $ApkPath -Leaf
$uploadUrl = $response.upload_url -replace "\{.*\}",""
$uploadUri = "$uploadUrl?name=$assetName"

Write-Output "Uploading asset $assetName to $uploadUri ..."
Invoke-RestMethod -Method Post -Uri $uploadUri -Headers $headers -InFile $ApkPath -ContentType "application/vnd.android.package-archive"

Write-Output "Release created: $($response.html_url)"
