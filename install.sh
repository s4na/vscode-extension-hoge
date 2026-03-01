#!/usr/bin/env bash
set -euo pipefail

REPO="s4na/vscode-extension-hoge"
TMP_FILE="/tmp/hoge.vsix"

# code コマンドの存在確認
if ! command -v code &>/dev/null; then
  echo "Error: 'code' command not found. Please install VSCode and add it to PATH." >&2
  exit 1
fi

echo "Fetching latest release from ${REPO}..."

DOWNLOAD_URL=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest" \
  | grep "browser_download_url.*\.vsix" \
  | head -1 \
  | cut -d '"' -f 4)

if [ -z "${DOWNLOAD_URL}" ]; then
  echo "Error: No .vsix asset found in the latest release." >&2
  exit 1
fi

echo "Downloading ${DOWNLOAD_URL}..."
curl -fsSL -o "${TMP_FILE}" "${DOWNLOAD_URL}"

echo "Installing extension..."
code --install-extension "${TMP_FILE}"

rm -f "${TMP_FILE}"
echo "Done! Reload VSCode to activate the extension."
