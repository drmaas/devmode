#!/usr/bin/env bash

set -euo pipefail

SCRIPT_SOURCE="${BASH_SOURCE[0]:-$0}"
REPO_ROOT="$(cd "$(dirname "${SCRIPT_SOURCE}")" && pwd)"
PREFIX="${PREFIX:-${HOME}/.local}"
BIN_DIR="${BIN_DIR:-${PREFIX}/bin}"
SHARE_DIR="${SHARE_DIR:-${PREFIX}/share/devmode}"
ACTION="${1:-install}"
DEVMODE_REPO="${DEVMODE_REPO:-drmaas/devmode}"
DEVMODE_REF="${DEVMODE_REF:-main}"
DEVMODE_ARCHIVE_URL="${DEVMODE_ARCHIVE_URL:-https://github.com/${DEVMODE_REPO}/archive/refs/heads/${DEVMODE_REF}.tar.gz}"
TEMP_SOURCE_DIR=""

cleanup() {
  if [[ -n "${TEMP_SOURCE_DIR}" && -d "${TEMP_SOURCE_DIR}" ]]; then
    rm -rf "${TEMP_SOURCE_DIR}"
  fi
}

trap cleanup EXIT

have_local_source() {
  [[ -d "${REPO_ROOT}/agents" ]] \
    && [[ -d "${REPO_ROOT}/bin" ]] \
    && [[ -d "${REPO_ROOT}/commands" ]] \
    && [[ -d "${REPO_ROOT}/skills" ]] \
    && [[ -d "${REPO_ROOT}/templates" ]]
}

resolve_source_root() {
  if have_local_source; then
    printf '%s\n' "${REPO_ROOT}"
    return
  fi

  command -v curl >/dev/null 2>&1 || {
    echo "Error: curl is required for remote installation." >&2
    exit 1
  }
  command -v tar >/dev/null 2>&1 || {
    echo "Error: tar is required for remote installation." >&2
    exit 1
  }

  TEMP_SOURCE_DIR="$(mktemp -d)"
  curl -fsSL "${DEVMODE_ARCHIVE_URL}" | tar -xzf - -C "${TEMP_SOURCE_DIR}"

  local extracted_root
  extracted_root="$(find "${TEMP_SOURCE_DIR}" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
  if [[ -z "${extracted_root}" ]]; then
    echo "Error: failed to extract devmode source archive from ${DEVMODE_ARCHIVE_URL}" >&2
    exit 1
  fi

  if [[ ! -d "${extracted_root}/agents" || ! -d "${extracted_root}/bin" || ! -d "${extracted_root}/commands" || ! -d "${extracted_root}/skills" || ! -d "${extracted_root}/templates" ]]; then
    echo "Error: extracted archive is missing required devmode assets." >&2
    exit 1
  fi

  printf '%s\n' "${extracted_root}"
}

case "${ACTION}" in
  install)
    SOURCE_ROOT="$(resolve_source_root)"
    mkdir -p "${BIN_DIR}" "${PREFIX}/share"
    rm -rf "${SHARE_DIR}"
    mkdir -p "${SHARE_DIR}"

    cp -R \
      "${SOURCE_ROOT}/agents" \
      "${SOURCE_ROOT}/bin" \
      "${SOURCE_ROOT}/commands" \
      "${SOURCE_ROOT}/skills" \
      "${SOURCE_ROOT}/templates" \
      "${SHARE_DIR}/"

    chmod +x "${SHARE_DIR}/bin/devmode"

    cat > "${BIN_DIR}/devmode" <<EOF
#!/usr/bin/env bash
set -euo pipefail
export DEVMODE_HOME="${SHARE_DIR}"
export DEVMODE_BIN_PATH="${BIN_DIR}/devmode"
exec "${SHARE_DIR}/bin/devmode" "\$@"
EOF

    chmod +x "${BIN_DIR}/devmode"

    cat <<EOF
Installed devmode
- binary: ${BIN_DIR}/devmode
- home:   ${SHARE_DIR}

Make sure ${BIN_DIR} is on your PATH, then run:
  cd /path/to/repo
  devmode install
EOF
    ;;
  uninstall)
    rm -f "${BIN_DIR}/devmode"
    rm -rf "${SHARE_DIR}"

    cat <<EOF
Removed devmode
- binary: ${BIN_DIR}/devmode
- home:   ${SHARE_DIR}
EOF
    ;;
  help|-h|--help)
    cat <<EOF
Usage:
  ./install.sh install
  ./install.sh uninstall

Remote install:
  curl -fsSL https://raw.githubusercontent.com/drmaas/devmode/refs/heads/main/install.sh | bash
  curl -fsSL https://raw.githubusercontent.com/drmaas/devmode/refs/heads/main/install.sh | bash -s uninstall

Environment overrides:
  PREFIX
  BIN_DIR
  SHARE_DIR
  DEVMODE_REPO
  DEVMODE_REF
  DEVMODE_ARCHIVE_URL
EOF
    ;;
  *)
    echo "Error: unknown action '${ACTION}'. Use install, uninstall, or help." >&2
    exit 1
    ;;
esac
