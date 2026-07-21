#!/bin/bash
set -euo pipefail

echo "=== opencode-termux Release Setup ==="
echo ""

# Check if gh is authenticated
if ! gh auth status &>/dev/null; then
    echo "Error: GitHub CLI not authenticated"
    echo "Run: gh auth login"
    exit 1
fi

# Extract version from package.json to keep in sync
VERSION=$(grep '"version"' package.json | head -1 | sed -E 's/.*"version"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/')
REPO="${REPO:-XxUs3rZer0xX/opencode-termux}"  # Use env var or default
ARCHIVE="opencode-termux-aarch64.tar.gz"

# Validate archive exists
if [[ ! -f "$ARCHIVE" ]]; then
    echo "Error: Archive file not found: $ARCHIVE"
    exit 1
fi

# Create repo if it doesn't exist
echo "Creating GitHub repo..."
gh repo create "$REPO" --private --description "OpenCode AI for Android Termux" 2>/dev/null || echo "Repo already exists"

# Upload release
echo "Creating release v${VERSION}..."
gh release create "v${VERSION}" "$ARCHIVE" \
    --title "v${VERSION}" \
    --notes "OpenCode for Android Termux (aarch64)" \
    --repo "$REPO"

echo ""
echo "Release created: https://github.com/${REPO}/releases/tag/v${VERSION}"
echo ""
echo "To publish to npm, run:"
echo "  npm publish"
