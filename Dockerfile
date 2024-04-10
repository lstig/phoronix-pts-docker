ARG BASE_IMAGE
ARG BASE_IMAGE_DIGEST
FROM ${BASE_IMAGE}@${BASE_IMAGE_DIGEST}

LABEL org.opencontainers.image.authors="Luke Stigdon <contact@lukestigdon.com>"
LABEL org.opencontainers.image.description="The Phoronix Test Suite open-source, cross-platform automated testing/benchmarking software."
LABEL org.opencontainers.image.licenses="GPL-3.0-or-later"
LABEL org.opencontainers.image.source="https://github.com/lstig/phoronix-pts-docker"
LABEL org.opencontainers.image.title="Phoronix Test Suite"
LABEL org.opencontainers.image.url="https://www.phoronix-test-suite.com"

ARG DEBIAN_FRONTEND=noninteractive

ADD build/base.tar.xz /

RUN apt-get update && \
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

ENTRYPOINT ["/phoronix-test-suite/phoronix-test-suite"]
CMD ["shell"]