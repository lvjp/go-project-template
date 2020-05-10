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

if [ -z "${SONAR_TOKEN:-}" ]; then
  echo "SONAR_TOKEN not found. Skip analysis."
  exit
fi

if [ "${PI_PLATFORM}" = "localhost" ]; then
  set -- -Dsonar.branch.name=local "$@"
fi

# XDG_CONFIG_HOME is a little workaround which kept jgit from create file
# ?/.config/jgit/config

./build/ci/shared/scripts/docker.sh \
  --env "SONAR_TOKEN=${SONAR_TOKEN}" \
  --env XDG_CONFIG_HOME=/tmp \
  sonarsource/sonar-scanner-cli:4.3 "$@"
