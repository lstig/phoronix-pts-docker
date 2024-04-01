phoronix-pts-docker
===

This repository contains code to build an up-to-date version of the [Phoronix Test Suite](http://www.phoronix-test-suite.com) inside a Docker container.

Notable changes and features:
- Updated base image to Ubuntu 22.04
- Added `php-sqlite3` package to enable running the [Phoromatic](http://www.phoronix-test-suite.com/?k=phoromatic) server
- Multi-arch builds: `linux/amd64`, `linux/arm64`

Download
---

```sh
docker pull ghcr.io/lstig/pts:latest
```