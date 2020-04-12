#!/usr/bin/env sh
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

set -o errexit
set -o nounset

cd "$(realpath "$(dirname "$0")/../../../..")"

. ./build/ci/shared/scripts/init.sh

fileList=$(mktemp)

trap 'rm "${fileList}"' EXIT

# Since bash 'set -o pipefail' is not defined in POSIX sh, we use a temporary file instead of a pipe.
git ls-files -z -- '*.sh' > "${fileList}"
xargs -0 ./build/ci/shared/scripts/docker.sh \
  koalaman/shellcheck-alpine:v0.7.0 \
  shellcheck \
  --external-sources \
  --check-sourced \
  --enable=add-default-case \
  --enable=require-variable-braces < "${fileList}"
