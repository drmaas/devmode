#!/usr/bin/env bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREFIX="${PREFIX:-${HOME}/.local}"
BIN_DIR="${BIN_DIR:-${PREFIX}/bin}"
SHARE_DIR="${SHARE_DIR:-${PREFIX}/share/devmode}"
ACTION="${1:-install}"

case "${ACTION}" in
  install)
    mkdir -p "${BIN_DIR}" "${PREFIX}/share"
    rm -rf "${SHARE_DIR}"
    mkdir -p "${SHARE_DIR}"

    cp -R \
      "${REPO_ROOT}/agents" \
      "${REPO_ROOT}/bin" \
      "${REPO_ROOT}/commands" \
      "${REPO_ROOT}/skills" \
      "${REPO_ROOT}/templates" \
      "${SHARE_DIR}/"

    chmod +x "${SHARE_DIR}/bin/devmode" "${SHARE_DIR}/bin/dm"

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
  devmode install /path/to/repo
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

Environment overrides:
  PREFIX
  BIN_DIR
  SHARE_DIR
EOF
    ;;
  *)
    echo "Error: unknown action '${ACTION}'. Use install, uninstall, or help." >&2
    exit 1
    ;;
esac
