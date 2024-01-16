#!/bin/bash

# Invoke rake to build _Steadfast Self-Hosting_
# Copyright (C) 2024  Adam Monsen
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

##############################################################
# Build the book: generate typeset output.                   #
##############################################################

set -o errexit
set -o nounset
set -o pipefail

bundle exec asciidoctor-pdf --attribute build_date_time="$BUILD_DATE_TIME" --attribute build_git_commit="$BUILD_GIT_COMMIT" --attribute build_os_release="$BUILD_OS_RELEASE" --warnings --trace --require ./extensions.rb print-this.adoc

cp print-this.pdf /outputs
