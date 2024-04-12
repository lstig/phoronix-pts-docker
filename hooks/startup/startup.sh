#!/usr/bin/env bash

PTS_USER_PATH=/var/lib/phoronix-test-suite

if [[ -n ${PTS_USER_PATH_OVERRIDE+x} ]]; then
  echo "[INFO] PTS_USER_PATH_OVERRIDE set: ${PTS_USER_PATH_OVERRIDE}"

  for src in test-profiles test-suites; do
    echo "[INFO] Moving ${PTS_USER_PATH}/${src} to ${PTS_USER_PATH_OVERRIDE}${src}"
    mkdir -p "${PTS_USER_PATH_OVERRIDE}${src}"
    find "${PTS_USER_PATH}/${src}"/* -maxdepth 0 ! -name local -print -exec mv -f -t "${PTS_USER_PATH_OVERRIDE}${src}" {} +
  done
else
  echo "[INFO] PTS_USER_PATH_OVERRIDE not set."
fi
