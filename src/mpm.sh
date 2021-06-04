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

# URLs needed to function
aur_url="https://aur.archlinux.org/"
arch_repository_search_url="https://archlinux.org/packages/search/json/?name="
arch_archive_url="https://archive.archlinux.org/"
arch_github_url="https://github.com/archlinux"

# The following are changed via the PKGBUILD at build time. If you'd like to
# modify them, export the variables (with the desired directories) to your
# shell's environment and run makedeb.
FUNCTIONS_DIR="."
REPO_DIR="/etc/mpm/repo/"
mpm_version="git"

##################
## BEGIN SCRIPT ##
##################
source <(cat "${FUNCTIONS_DIR}"/functions/*.sh)
source <(cat "${FUNCTIONS_DIR}"/functions/*/*.sh)
set -e

trap_codes
arg_check ${@}

case ${OP} in
	search)        search_pkg ;;
	install)       install_pkg ;;
	upgrade)       update_pkg ;;
	clone)         clone_pkg ;;
esac
