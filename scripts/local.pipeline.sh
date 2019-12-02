#!/usr/bin/env bash
# Copyright (C) 2019 VERDOÏA Laurent
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

export LOCALHOST_CI=true

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

cd "$(realpath "$(dirname "$0")/..")"

dockerRun() {
  docker run \
    --tty --rm \
    --env LOCALHOST_CI="${LOCALHOST_CI}" \
    --volume "${PWD}:/work" --workdir /work \
    "$@"
}

dockerRunCached() {
  dockerRun \
    --env GOPATH=/go \
    --volume "${PWD}/.go-cache:/go" \
    "$@"
}

dockerRunGolang() {
  dockerRunCached \
    golang:1.13.4-buster \
    "$@"
}

dockerRunGolang ./build/ci/nutshell/jobs/go-test.sh

dockerRun koalaman/shellcheck-alpine:v0.7.0 ./build/ci/nutshell/jobs/shellcheck.sh
dockerRun --entrypoint sh mvdan/shfmt:v2.6.4 ./build/ci/nutshell/jobs/shfmt.sh

dockerRunGolang ./build/ci/nutshell/jobs/go-mod-tidy.sh
dockerRunGolang ./build/ci/nutshell/jobs/go-fmt.sh
dockerRunCached golangci/golangci-lint:v1.21-alpine ./build/ci/nutshell/jobs/go-golangci-lint.sh
dockerRunCached --entrypoint sh registry.gitlab.com/lvjp/docker-golint:alpine ./build/ci/nutshell/jobs/go-lint.sh

echo Done
