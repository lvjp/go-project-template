#!/usr/bin/env sh
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

set -o errexit
set -o nounset

cd "$(realpath "$(dirname "$0")/../../../..")"

. ./build/ci/shared/scripts/init.sh
. ./build/ci/shared/scripts/functions.sh

goBootstrap

mkdir -p dist

goTest() {
  if [ "${PI_DEBUG_TRACE}" = "true" ]; then
    set -- -v "$@"
  fi

  set +e
  go test "$@"
  testStatus=$?
  set -e
}

goTest -coverpkg=gitlab.com/lvjp/go-project-template/... -coverprofile=dist/coverage.out -bench=. ./...
go tool cover -func=dist/coverage.out
go tool cover -html=dist/coverage.out -o dist/coverage.html

exit ${testStatus}
