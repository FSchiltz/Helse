#!/usr/bin/env bash
set -euo pipefail

if (($# > 1)); then
  echo "Usage: $0 [linux-bundle-directory]" >&2
  exit 2
fi

if ! command -v xdg-mime >/dev/null 2>&1; then
  echo "xdg-mime is required to register the OAuth callback URL scheme." >&2
  exit 1
fi

bundle_dir=${1:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)}
bundle_dir=$(cd -- "$bundle_dir" && pwd -P)
application="$bundle_dir/helse"

if [[ ! -x "$application" ]]; then
  echo "Helse executable not found in Linux bundle: $application" >&2
  exit 1
fi

data_home=${XDG_DATA_HOME:-${HOME:?HOME is not set}/.local/share}
applications_dir="$data_home/applications"
desktop_file="$applications_dir/com.fschiltz.helse.desktop"
escaped_application=$(
  printf '%s' "$application" | sed 's/\\/\\\\/g; s/"/\\"/g; s/%/%%/g'
)

mkdir -p "$applications_dir"
cat >"$desktop_file" <<EOF
[Desktop Entry]
Type=Application
Name=Helse OAuth Callback
NoDisplay=true
Terminal=false
Exec=env "$escaped_application" %u
MimeType=x-scheme-handler/com.helse;
EOF

xdg-mime default "$(basename "$desktop_file")" x-scheme-handler/com.helse

if [[ $(xdg-mime query default x-scheme-handler/com.helse) != "$(basename "$desktop_file")" ]]; then
  echo "Failed to register Helse as the com.helse URL handler." >&2
  exit 1
fi

echo "Registered com.helse:// callbacks for $application"
