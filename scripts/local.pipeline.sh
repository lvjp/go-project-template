#!/usr/bin/env bash
# Copyright (C) 2019-2020 VERDOÏA Laurent
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

# Run inside a docker with a cached GOPATH.
# If local and docker arch is same, reuse local $(go env GOPATH) folder.
# If not, use ${HOME}/.cache/go/OS/Arch instead.
dockerRunCached() {
  local client
  client=$(docker version --format '{{.Client.Os}}/{{.Client.Arch}}')
  local server
  server=$(docker version --format '{{.Server.Os}}/{{.Server.Arch}}')

  if [ "${client}" = "${server}" ] && command -v go &> /dev/null; then
    folder=$(go env GOPATH)
    if [ -z "${folder}" ]; then
      # shellcheck disable=SC2016
      echo 'Cannot detect $(go env GOPATH)' >&2
      exit 1
    fi
  else
    folder="${HOME}/.cache/go/${server}"
    if [ ! -d "${folder}" ]; then
      mkdir -p "${folder}"
    fi
  fi

  dockerRun \
    --env GOPATH=/go \
    --volume "${folder}:/go" \
    "$@"
}

dockerRunGolang() {
  dockerRunCached \
    golang:1.14.2-buster \
    "$@"
}

dockerRunGolang ./build/ci/shared/jobs/go-test.sh

./build/ci/shared/jobs/shellcheck.sh
./build/ci/shared/jobs/shfmt.sh

dockerRunGolang ./build/ci/shared/jobs/go-mod-tidy.sh
dockerRunGolang ./build/ci/shared/jobs/go-fmt.sh
dockerRunCached golangci/golangci-lint:v1.23.8-alpine ./build/ci/shared/jobs/go-golangci-lint.sh
dockerRunCached --entrypoint sh registry.gitlab.com/lvjp/docker-golint:alpine ./build/ci/shared/jobs/go-lint.sh

dockerRun \
  --entrypoint bash \
  --env "SONAR_TOKEN=${SONAR_TOKEN:-}" \
  sonarsource/sonar-scanner-cli:4.3 \
  ./build/ci/shared/jobs/sonar-scanner.sh \
  -Dsonar.branch.name=local

echo Done
