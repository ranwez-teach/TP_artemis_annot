#!/usr/bin/env bash
set -euo pipefail

ARTEMIS_BIN="${ARTEMIS_BIN:-/opt/artemis/art}"

if [[ ! -x "${ARTEMIS_BIN}" ]]; then
  echo "Missing Artemis executable: ${ARTEMIS_BIN}" >&2
  exit 1
fi

if [[ ! -f "/opt/artemis/artemis.jar" ]]; then
  echo "Missing Artemis jar: /opt/artemis/artemis.jar" >&2
  exit 1
fi

java -version
"${ARTEMIS_BIN}" -help >/tmp/artemis-help.txt 2>&1 || true
head -40 /tmp/artemis-help.txt
