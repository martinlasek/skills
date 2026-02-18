#!/usr/bin/env bash

# Exit on first error (`-e`), undefined variable (`-u`), or failed pipeline (`-o pipefail`).
set -euo pipefail

# Resolve the directory where this script lives so it works from any current directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define where Codex expects installed skills on macOS.
DEST_DIR="${HOME}/.codex/skills"

# Define the skills from this repository that should be installed.
SKILLS=(
  "swift-coding-guideline"
  "swiftui-coding-guideline"
)

# Print usage help for selecting specific skills.
usage() {
  cat <<'EOF'
Usage:
  ./install.sh
  ./install.sh <skill-name> [<skill-name> ...]

Behavior:
  - No arguments: install all skills from this repository.
  - With arguments: install only the provided skill names.
EOF
}

# Return success when the provided skill is part of this repository.
is_known_skill() {
  local candidate="$1"

  for known in "${SKILLS[@]}"; do
    if [[ "${known}" == "${candidate}" ]]; then
      return 0
    fi
  done

  return 1
}

# Build the install list:
# - Default to all skills.
# - If arguments are provided, validate and use them.
INSTALL_LIST=()
if [[ "$#" -eq 0 ]]; then
  INSTALL_LIST=("${SKILLS[@]}")
else
  for requested in "$@"; do
    if [[ "${requested}" == "-h" || "${requested}" == "--help" ]]; then
      usage
      exit 0
    fi

    if ! is_known_skill "${requested}"; then
      echo "Error: unknown skill '${requested}'."
      echo "Available skills: ${SKILLS[*]}"
      usage
      exit 1
    fi

    INSTALL_LIST+=("${requested}")
  done
fi

# Ensure the destination directory exists (safe if it already exists).
mkdir -p "${DEST_DIR}"

echo "Installing skills into: ${DEST_DIR}"
echo "Selected skills: ${INSTALL_LIST[*]}"

# Install each skill folder one by one.
for skill in "${INSTALL_LIST[@]}"; do
  # Build absolute source and destination paths for the current skill.
  src="${SCRIPT_DIR}/${skill}"
  dest="${DEST_DIR}/${skill}"

  # Stop immediately if the source skill folder is missing in this repo checkout.
  if [[ ! -d "${src}" ]]; then
    echo "Error: source skill folder not found: ${src}"
    exit 1
  fi

  # If this skill is already installed, move it to a timestamped backup first.
  if [[ -d "${dest}" ]]; then
    backup="${dest}.backup.$(date +%Y%m%d-%H%M%S)"
    mv "${dest}" "${backup}"
    echo "Backed up existing ${skill} to ${backup}"
  fi

  # Copy the skill folder into Codex's skills directory.
  cp -R "${src}" "${DEST_DIR}/"
  echo "Installed ${skill}"
done

echo
echo "Done. Restart Codex to pick up the newly installed skills."
