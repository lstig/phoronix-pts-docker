ARG BASE_IMAGE
ARG BASE_IMAGE_DIGEST
FROM ${BASE_IMAGE}@${BASE_IMAGE_DIGEST}

LABEL org.opencontainers.image.authors="Luke Stigdon <contact@lukestigdon.com>"
LABEL org.opencontainers.image.description="The Phoronix Test Suite open-source, cross-platform automated testing/benchmarking software."
LABEL org.opencontainers.image.licenses="GPL-3.0-or-later"
LABEL org.opencontainers.image.source="https://github.com/lstig/phoronix-pts-docker"
LABEL org.opencontainers.image.title="Phoronix Test Suite"
LABEL org.opencontainers.image.url="https://www.phoronix-test-suite.com"

WORKDIR /usr/share/phoronix-test-suite

COPY phoronix-test-suite/pts-core /usr/share/phoronix-test-suite/pts-core
COPY phoronix-test-suite/phoronix-test-suite /usr/bin/phoronix-test-suite

ARG PTS_DOWNLOAD_CACHING_PLATFORM_LIMIT=1
ARG DEBIAN_FRONTEND=noninteractive

RUN rm -rf \
        pts-core/static/phoronix-test-suite.desktop \
        pts-core/static/phoronix-test-suite-launcher.desktop \
        pts-core/openbenchmarking.org/openbenchmarking-mime.xml \
        pts-core/static/bash_completion \
        pts-core/static/images/openbenchmarking.png \
        pts-core/static/images/%phoronix-test-suite.png && \
    sed -i 's:export PTS_DIR=$(readlink -f `dirname $0`):export PTS_DIR=/usr/share/phoronix-test-suite:g' /usr/bin/phoronix-test-suite && \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        # system packages
        apt-utils apt-file sudo \
        # build utils
        build-essential git-core \
        # libs and utils
        unzip xz-utils mesa-utils \
        # php
        php-cli php-gd php-xml php-sqlite3 && \
    apt-file update

RUN phoronix-test-suite make-openbenchmarking-cache lean && \
    rm -rf /var/lib/phoronix-test-suite/core.pt2so

WORKDIR /

ENTRYPOINT ["phoronix-test-suite"]
CMD ["shell"]