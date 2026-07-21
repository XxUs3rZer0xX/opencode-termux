# PowerShell version of setup-release.sh
$ErrorActionPreference = "Stop"

Write-Host "=== opencode-termux Release Setup ===" -ForegroundColor Green
Write-Host ""

# Check if gh is authenticated
try {
    gh auth status 2>&1 | Out-Null
} catch {
    Write-Host "Error: GitHub CLI not authenticated" -ForegroundColor Red
    Write-Host "Run: gh auth login"
    exit 1
}

# Extract version from package.json
$packageJson = Get-Content package.json | ConvertFrom-Json
$VERSION = $packageJson.version
$REPO = "XxUs3rZer0xX/opencode-termux"
$ARCHIVE = "opencode-termux-aarch64.tar.gz"

# Validate archive exists
if (-not (Test-Path $ARCHIVE)) {
    Write-Host "Error: Archive file not found: $ARCHIVE" -ForegroundColor Red
    exit 1
}

Write-Host "Creating release v${VERSION}..." -ForegroundColor Cyan

# Create release
gh release create "v${VERSION}" "$ARCHIVE" `
    --title "v${VERSION}" `
    --notes "OpenCode for Android Termux (aarch64)" `
    --repo "$REPO"

Write-Host ""
Write-Host "Release created: https://github.com/${REPO}/releases/tag/v${VERSION}" -ForegroundColor Green
Write-Host ""
Write-Host "To publish to npm, run:" -ForegroundColor Yellow
Write-Host "  npm publish"
