#!/usr/bin/env bash
set -euo pipefail

REPO="s4na/vscode-extension-hoge"
TMP_FILE="$(mktemp /tmp/hoge-XXXXXX.vsix)"
trap 'rm -f "${TMP_FILE}"' EXIT

# code コマンドの存在確認
if ! command -v code &>/dev/null; then
  echo "Error: 'code' command not found. Please install VSCode and add it to PATH." >&2
  exit 1
fi

echo "Fetching latest release from ${REPO}..."

API_RESPONSE=$(curl -fsSL "https://api.github.com/repos/${REPO}/releases/latest") || {
  echo "Error: Failed to fetch release info from GitHub API." >&2
  exit 1
}

# レート制限チェック
if echo "${API_RESPONSE}" | grep -q '"message".*"API rate limit exceeded"'; then
  echo "Error: GitHub API rate limit exceeded. Please try again later." >&2
  exit 1
fi

# jq が利用可能なら使用し、なければ grep + cut にフォールバック
if command -v jq &>/dev/null; then
  DOWNLOAD_URL=$(echo "${API_RESPONSE}" \
    | jq -r '.assets[] | select(.name | endswith(".vsix")) | .browser_download_url' \
    | head -1)
else
  DOWNLOAD_URL=$(echo "${API_RESPONSE}" \
    | grep "browser_download_url.*\.vsix" \
    | head -1 \
    | cut -d '"' -f 4)
fi

if [ -z "${DOWNLOAD_URL}" ]; then
  echo "Error: No .vsix asset found in the latest release." >&2
  exit 1
fi

echo "Downloading ${DOWNLOAD_URL}..."
curl -fsSL -o "${TMP_FILE}" "${DOWNLOAD_URL}" || {
  echo "Error: Failed to download .vsix from ${DOWNLOAD_URL}" >&2
  exit 1
}

echo "Installing extension..."
code --install-extension "${TMP_FILE}"

echo "Done! Reload VSCode to activate the extension."
