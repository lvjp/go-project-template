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

./build/ci/shared/scripts/docker.sh \
  registry.gitlab.com/lvjp/docker-golint:alpine \
  -set_exit_status ./...
