ARG BASE_DIGEST=""
FROM public.ecr.aws/ubuntu/ubuntu:22.04${BASE_DIGEST}

# Build time tags:
# org.opencontainers.image.base.digest="unkown"
# org.opencontainers.image.revision="0000000"
# org.opencontainers.image.created="1970-01-01T00:00:01Z"
# org.opencontainers.image.version="unknown"

LABEL org.opencontainers.image.authors="Luke Stigdon <contact@lukestigdon.com>"
LABEL org.opencontainers.image.description="The Phoronix Test Suite open-source, cross-platform automated testing/benchmarking software."
LABEL org.opencontainers.image.licenses="GPL-3.0-or-later"
LABEL org.opencontainers.image.source="https://github.com/lstig/phoronix-pts-docker"
LABEL org.opencontainers.image.title="Phoronix Test Suite"
LABEL org.opencontainers.image.url="https://www.phoronix-test-suite.com"
LABEL org.opencontainers.image.base.name="public.ecr.aws/ubuntu/ubuntu:22.04"

ARG DEBIAN_FRONTEND=noninteractive

ADD build/base.tar.xz /

RUN apt-get update && \
    apt-get install --no-install-recommends -y unzip php-cli apt-utils mesa-utils php-xml php-sqlite3 git-core apt-file sudo && \
    apt-file update

ENTRYPOINT ["/phoronix-test-suite/phoronix-test-suite"]
CMD ["shell"]