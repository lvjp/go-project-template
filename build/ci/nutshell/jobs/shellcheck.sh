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

. ./build/ci/nutshell/scripts/bootstrap.sh

fileList=$(mktemp)

trap 'rm "${fileList}"' EXIT

# Since there 'set -o pipefail' is not defined in POSIX sh, we use a temporary file instead of a pipe.
find . -path ./.git -prune -or -type f -name '*.sh' -print0 > "${fileList}"
xargs -0 shellcheck \
  --external-sources \
  --check-sourced \
  --enable=add-default-case \
  --enable=require-variable-braces \
  < "${fileList}"
