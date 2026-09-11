#!/usr/bin/env bash
set -euo pipefail

export DISPLAY="${DISPLAY:-:1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_FILE="${1:-${SCRIPT_DIR}/data/example.embl}"
FALLBACK_DATA_FILE="${ARTEMIS_FALLBACK_DATA_FILE:-/opt/artemis/etc/c1215.embl}"
LOG_FILE="${ARTEMIS_LOG:-/tmp/artemis.log}"
ARTEMIS_BIN="${ARTEMIS_BIN:-}"

echo "Artemis TP startup: $(date)" >"${LOG_FILE}"
echo "Display: ${DISPLAY}" >>"${LOG_FILE}"
echo "Data file: ${DATA_FILE}" >>"${LOG_FILE}"
echo "Fallback data file: ${FALLBACK_DATA_FILE}" >>"${LOG_FILE}"

if [[ -z "${ARTEMIS_BIN}" ]]; then
  for candidate in /opt/artemis/art "$(command -v art || true)" "$(command -v artemis || true)"; do
    if [[ -n "${candidate}" && -x "${candidate}" ]]; then
      ARTEMIS_BIN="${candidate}"
      break
    fi
  done
fi

if [[ -z "${ARTEMIS_BIN}" || ! -x "${ARTEMIS_BIN}" ]]; then
  {
    echo "Artemis executable not found."
    echo "Expected /opt/artemis/art, or an art/artemis command in PATH."
    echo
    echo "This usually means the Codespace was created before .devcontainer was pushed,"
    echo "or it has not been rebuilt after the devcontainer files were added."
    echo
    echo "Try in GitHub Codespaces:"
    echo "  Command Palette > Codespaces: Rebuild Container"
    echo
    echo "Or delete this Codespace and create a fresh one from the current branch."
  } >>"${LOG_FILE}"
  cat "${LOG_FILE}"
  exit 0
fi

echo "Artemis executable: ${ARTEMIS_BIN}" >>"${LOG_FILE}"

if [[ ! -f "${DATA_FILE}" ]]; then
  if [[ -f "${FALLBACK_DATA_FILE}" ]]; then
    echo "Data file not found: ${DATA_FILE}; using ${FALLBACK_DATA_FILE}." >>"${LOG_FILE}"
    DATA_FILE="${FALLBACK_DATA_FILE}"
  else
    echo "Data file not found: ${DATA_FILE}" >>"${LOG_FILE}"
    cat "${LOG_FILE}"
    exit 0
  fi
fi

for _ in $(seq 1 30); do
  if xdpyinfo -display "${DISPLAY}" >/dev/null 2>&1; then
    break
  fi
  sleep 1
done

if ! xdpyinfo -display "${DISPLAY}" >/dev/null 2>&1; then
  echo "Desktop display ${DISPLAY} is not ready yet." >>"${LOG_FILE}"
  cat "${LOG_FILE}"
  exit 0
fi

if pgrep -u "$(id -u)" -f "uk\\.ac\\.sanger\\.artemis\\.components\\.ArtemisMain|/opt/artemis/.*/?artemis\\.jar" >/dev/null; then
  echo "Artemis is already running for this user." >>"${LOG_FILE}"
  exit 0
fi

cd "${SCRIPT_DIR}"
nohup "${ARTEMIS_BIN}" "${DATA_FILE}" >>"${LOG_FILE}" 2>&1 &
echo "Artemis launched with PID $!." >>"${LOG_FILE}"

sleep 3

if ! pgrep -u "$(id -u)" -f "uk\\.ac\\.sanger\\.artemis\\.components\\.ArtemisMain" >/dev/null; then
  echo "Artemis is not running after startup. See previous Java output in this log." >>"${LOG_FILE}"
  if [[ "${DATA_FILE}" != "${FALLBACK_DATA_FILE}" && -f "${FALLBACK_DATA_FILE}" ]]; then
    echo "Retrying with official Artemis sample: ${FALLBACK_DATA_FILE}" >>"${LOG_FILE}"
    nohup "${ARTEMIS_BIN}" "${FALLBACK_DATA_FILE}" >>"${LOG_FILE}" 2>&1 &
    echo "Fallback Artemis launched with PID $!." >>"${LOG_FILE}"
  fi
fi

if command -v xterm >/dev/null 2>&1; then
  nohup xterm -geometry 120x32+40+40 -title "Artemis TP log" -e "tail -f ${LOG_FILE}" >/tmp/artemis-xterm.log 2>&1 &
  echo "Log xterm launched with PID $!." >>"${LOG_FILE}"
fi
