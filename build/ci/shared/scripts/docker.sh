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

if [ "${PI_DEBUG_TRACE}" = "true" ]; then
  set -o xtrace
fi

# Since docker need absolute path for directory mount,
# we firstly go to project root.
cd "$(realpath "$(dirname "$0")/../../../..")"

if [ "${PI_PLATFORM}" = "localhost" ]; then
  # --tty option permit to have beautiful output on some tools.
  set -- --tty "$@"

  set -- --user "$(id -u):$(id -g)" "$@"
fi

docker run \
  --mount "type=bind,src=${PWD},dst=/work" \
  --workdir /work \
  "$@"
