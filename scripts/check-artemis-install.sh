#!/usr/bin/env bash
set -euo pipefail

ARTEMIS_BIN="${ARTEMIS_BIN:-}"

if [[ -z "${ARTEMIS_BIN}" ]]; then
  for candidate in /opt/artemis/art "$(command -v art || true)" "$(command -v artemis || true)"; do
    if [[ -n "${candidate}" && -x "${candidate}" ]]; then
      ARTEMIS_BIN="${candidate}"
      break
    fi
  done
fi

if [[ -z "${ARTEMIS_BIN}" || ! -x "${ARTEMIS_BIN}" ]]; then
  echo "Artemis is not installed in this container." >&2
  echo "Expected /opt/artemis/art, or an art/artemis command in PATH." >&2
  echo >&2
  echo "If you are in GitHub Codespaces, rebuild the container:" >&2
  echo "  Command Palette > Codespaces: Rebuild Container" >&2
  echo >&2
  echo "If that still fails, delete the Codespace and create a new one from the current branch." >&2
  exit 1
fi

ARTEMIS_DIR="$(cd "$(dirname "${ARTEMIS_BIN}")" && pwd)"

if [[ ! -f "${ARTEMIS_DIR}/artemis.jar" ]]; then
  echo "Missing Artemis jar: ${ARTEMIS_DIR}/artemis.jar" >&2
  exit 1
fi

java -version
"${ARTEMIS_BIN}" -help >/tmp/artemis-help.txt 2>&1 || true
head -40 /tmp/artemis-help.txt
