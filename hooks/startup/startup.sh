#!/usr/bin/env bash

PTS_USER_PATH=/var/lib/phoronix-test-suite/

if [[ -n ${PTS_USER_PATH_OVERRIDE+x} ]]; then
  echo "[INFO] PTS_USER_PATH_OVERRIDE set: ${PTS_USER_PATH_OVERRIDE}"

  mkdir -p "${PTS_USER_PATH_OVERRIDE}"
  rsync -av --exclude=core.pt2so --delete "${PTS_USER_PATH}" "${PTS_USER_PATH_OVERRIDE}"
else
  echo "[INFO] PTS_USER_PATH_OVERRIDE not set."
fi

if [[ -n ${PTS_USER_CACHE_DOWNLOADS+x} ]]; then
  echo "[INFO] PTS_USER_CACHE_DOWNLOADS set."

  phoronix-test-suite make-download-cache ${PTS_USER_CACHE_DOWNLOADS}
else
  echo "[INFO] PTS_USER_CACHE_DOWNLOADS not set."
fi
