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

if [ "${LOCALHOST_CI:-}" = "true" ]; then
  PI_PLATFORM=localhost
else
  echo "Could not detect CI platform" >&2
  exit 1
fi

echo "Detected CI platform: ${PI_PLATFORM}"
# shellcheck source=/dev/null
. ./build/ci/${PI_PLATFORM}/env.sh

case "${PI_PLATFORM}" in
  localhost) PI_SERVER=false ;;
  *) PI_SERVER=true ;;
esac
export PI_SERVER

case "${PI_DEBUG_TRACE}" in
  true | false) ;;
  yes) PI_DEBUG_TRACE=true ;;
  *) PI_DEBUG_TRACE=false ;;
esac

if [ "${PI_DEBUG_TRACE}" = "true" ]; then
  set -o xtrace
  env | grep ^PI_
fi
