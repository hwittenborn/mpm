#!/usr/bin/bash
# Copyright 2020-2021 Hunter Wittenborn <hunter@hunterwittenborn.com>
##
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

# Options
URL="https://aur.archlinux.org/"
LIST_PER_PACKAGE="FALSE"

# The following are changed via the PKGBUILD at build time. If you'd like to
# modify them, edit the variables there.
FUNCTIONS_DIR="."
REPO_DIR="/etc/mpm/repo/"

##################
## BEGIN SCRIPT ##
##################
source <(cat "${FUNCTIONS_DIR}"/functions/*.sh)
source <(cat "${FUNCTIONS_DIR}"/functions/*/*.sh)

arg_check ${@}
case ${OP} in
	search)        search_pkg ;;
	install)       install_pkg ;;
	update)        update_pkg ;;
	clone)         clone_pkg ;;
esac
