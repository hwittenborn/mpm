#!/usr/bin/bash
# Copyright 2020 Hunter Wittenborn <git@hunterwittenborn.me>
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

## DEFAULT VARIABLES ##
URL="https://aur.archlinux.org/"

## VARIABLES ##
CURRENT_USER="$(id -u)"
BUILD_USER="$(whoami)"
ROOT_CONFIRM="TRUE"

root_check() {
	## CHECKS WHEN RUNNING AS ROOT ##
	if [[ "${CURRENT_USER}" == "0" ]] && [[ ${BUILD_USER} == "root" ]]; then
		echo "A user other than 'root' must be specified to build as when running mpm as root"
		exit 1

	elif [[ "${CURRENT_USER}" == "0" ]] && ! id ${BUILD_USER} &> /dev/null; then
		echo "User '${BUILD_USER}' doesn't exist"
		exit 1

	## OBTAIN ROOT PRIVILEGES WHEN NOT RUNNING AS ROOT ##
	else
		echo "Obtaining root privileges..."
		sudo echo &> /dev/null
		if [[ ${?} != "0" ]]; then
	 		echo "Couldn't get root privileges"
	 		exit 1
 		fi
	fi
}

arg_check() {
	while true; do
		case ${1} in
			--help | "")        help ;;
			-L | --list-pkg)    LPP="TRUE" ;;
			-U | --user)        BUILD_USER="${2}"; shift 1 ;;
			-*)                 echo "Unknown option '${1}'"; exit 1 ;;

			search)        OP="search"; shift 1; break ;;
			install)       OP="install"; shift 1; break ;;
			update)        OP="update"; PKG="TEMP"; shift 1; break ;;
			*)             echo "Invalid option '{1}'..."; exit 1 ;;
		esac
		shift 1
	done

	while true; do
		case ${1} in
			--help)             help ;;
			-L | --list-pkg)    LPP="TRUE" ;;
			-U | --user)        BUILD_USER="${2}"; shift 1 ;;
			-*)                 echo "Invalid option '${1}'"; exit 1 ;;
			"")                 break ;;
			*)                  PKG+=" ${1}" ;;
		esac
		shift 1
	done

	if [[ "${PKG}" == "" ]]; then
		echo "Package field is empty"
		exit 1
	fi
}

help() {
	echo "mpm - makedeb package manager"
	echo "Usage: mpm [command] [options]"
	echo
	echo "Commands"
	echo "  search - search for a package"
	echo "  install - install packages from the AUR"
	echo "  update - update installed AUR packages"
	echo
	echo "Options:"
	echo "  --help - bring up this help menu"
	echo "  -L, --list-pkg - list each package as it's rendered; for use with 'search'"
	echo "  -U, --user - specify a user to build as when running as root"
	echo
	echo "Report bugs at https://github.com/hwittenborn/mpm"
	exit 0
}

search_pkg() {
	PKG=$(echo "${PKG}" | sed 's/ //')

	echo "Searching for '${PKG}'..."

	URL="${URL}rpc.php/rpc/?v=5&type=search&arg=${PKG}"
	RESULTS=$(curl -s "${URL}" | jq)

	if [[ $(echo ${RESULTS} | jq -r '.resultcount') == "0" ]]; then
		echo "No results"
		exit 0
	elif [[ $(echo ${RESULTS} | jq -r '.resultcount') > "50" ]]; then
		echo "Large amount of results detected. This might take a bit..."
	fi

	PKGNUM="1"
	if [[ ${LPP} = "TRUE" ]]; then
		for pkg in $(echo ${RESULTS} | jq -r '.results[].Name'); do
			echo "$(
				echo
				echo "$(echo ${RESULTS} | jq -r '.results[].Name' | awk NR==${PKGNUM})/$(echo ${RESULTS} | jq -r '.results[].Version' | awk NR==${PKGNUM})"
				echo "  Description: $(echo ${RESULTS} | jq -r '.results[].Description' | awk NR==${PKGNUM})"
				echo "  Votes: $(echo ${RESULTS} | jq -r '.results[].NumVotes' | awk NR==${PKGNUM})"

				MAINTAINER="$(echo ${RESULTS} | jq -r '.results[].Maintainer' | awk NR==${PKGNUM})"
				if [[ "${MAINTAINER}" == "null" ]]; then
					MAINTAINER="ORPHANED"
				fi
				echo "  Maintainer: ${MAINTAINER}"

				OUTOFDATE="$(echo ${RESULTS} | jq -r '.results[].OutOfDate' | awk NR==${PKGNUM})"
				if [[ "${OUTOFDATE}" == "null" ]]; then
					OUTOFDATE="N/A"
				else
					OUTOFDATE=$(date -d "@$(echo ${RESULTS} | jq -r '.results[].OutOfDate' | awk NR==${PKGNUM})" +%m-%d-%Y)
				fi
				echo "  Out Of Date: ${OUTOFDATE}"

				LASTMODIFIED="$(date -d @$(echo ${RESULTS} | jq -r '.results[].LastModified' | awk NR==${PKGNUM}) +%m-%d-%Y)"
				echo "  Last Modified: ${LASTMODIFIED}"
			)"

			PKGNUM=$((${PKGNUM} + 1))
		done
	else
		echo "$(
			for pkg in $(echo ${RESULTS} | jq -r '.results[].Name'); do
				echo
				echo "$(echo ${RESULTS} | jq -r '.results[].Name' | awk NR==${PKGNUM})/$(echo ${RESULTS} | jq -r '.results[].Version' | awk NR==${PKGNUM})"
				echo "  Description: $(echo ${RESULTS} | jq -r '.results[].Description' | awk NR==${PKGNUM})"
				echo "  Votes: $(echo ${RESULTS} | jq -r '.results[].NumVotes' | awk NR==${PKGNUM})"

				MAINTAINER="$(echo ${RESULTS} | jq -r '.results[].Maintainer' | awk NR==${PKGNUM})"
				if [[ "${MAINTAINER}" == "null" ]]; then
					MAINTAINER="ORPHANED"
				fi
				echo "  Maintainer: ${MAINTAINER}"

				OUTOFDATE="$(echo ${RESULTS} | jq -r '.results[].OutOfDate' | awk NR==${PKGNUM})"
				if [[ "${OUTOFDATE}" == "null" ]]; then
					OUTOFDATE="N/A"
				else
					OUTOFDATE=$(date -d "@$(echo ${RESULTS} | jq -r '.results[].OutOfDate' | awk NR==${PKGNUM})" +%m-%d-%Y)
				fi
				echo "  Out Of Date: ${OUTOFDATE}"

				LASTMODIFIED="$(date -d @$(echo ${RESULTS} | jq -r '.results[].LastModified' | awk NR==${PKGNUM}) +%m-%d-%Y)"
				echo "  Last Modified: ${LASTMODIFIED}"

				PKGNUM=$((${PKGNUM} + 1))
			done
		)"
	fi
}

install_pkg() {
	root_check
	PKG=$(echo "${PKG}" | sed 's/ //')
	for package in ${PKG}; do
		CHECK_URL="${URL}rpc.php/rpc/?v=5&type=info&arg=${package}"
		RESULTS=$(curl -s "${CHECK_URL}" | jq)

		if [[ $(echo ${RESULTS} | jq -r '.resultcount') == "0" ]]; then
			FIND_NULL+=" ${package}"
		fi
	done

	FIND_NULL=$(echo "${FIND_NULL}" | sed 's/ //')
	if [[ ${FIND_NULL} != "" ]]; then
		echo "Couldn't find package(s) ${FIND_NULL}"
		exit 1
	fi

	ls /tmp/"${BUILD_USER}"/makedeb &> /dev/null
	if [[ ${?} == "0" ]]; then
		sudo rm -r /tmp/"${BUILD_USER}"/makedeb &> /dev/null
	fi

	sudo mkdir -p /tmp/"${BUILD_USER}"/makedeb &> /dev/null
	sudo chown "${BUILD_USER}" /tmp/"${BUILD_USER}"/makedeb
	cd /tmp/"${BUILD_USER}"/makedeb

	echo "Cloning build files..."
	for package in ${PKG}; do
		git clone "${URL}${package}.git" &> /dev/null
	done

	for package in ${PKG}; do
		echo "Look over files for '${package}'?"
		echo "Enter yes(y) or no(n)"
		read -p "[>>] " check_files

		while [[ ${check_files} != "yes" ]] && [[ ${check_files} != "y" ]] && [[ ${check_files} != "no" ]] && [[ ${check_files} != "n" ]]; do
			echo "Invalid option provided"
			echo " Enter yes(y) or no(n)"
			read -p "[>>] " check_files
		done

		while [[ ${check_files} == "yes" ]] || [[ ${check_files} == "y" ]]; do
			nano "${package}"/PKGBUILD
			source "${package}"/PKGBUILD
			for notlink in ${source[@]}; do
				echo "${notlink}" | grep "http" &> /dev/null
				if [[ ${?} != "0" ]]; then
					nano "${package}"/"${notlink}"
				fi
			done
			sleep 1

			echo "Look over files for '${package}'?"
			echo "Enter yes(y) or no(n)"
			read -p "[>>] " check_files

			while [[ ${check_files} != "yes" ]] && [[ ${check_files} != "y" ]] && [[ ${check_files} != "no" ]] && [[ ${check_files} != "n" ]]; do
				echo "Invalid option provided"
				echo " Enter yes(y) or no(n)"
				read -p "[>>] " check_files
			done
		done
	done

	echo "Building ${PKG}..."
	for package in ${PKG}; do
		cd "${package}"
		sudo -u "${BUILD_USER}" makedeb --user "${BUILD_USER}" --convert --skip-rootcheck
		CONTROL_NAME="$(cat pkg/DEBIAN/control | grep "Package:" | awk '{print $2}')_$(cat pkg/DEBIAN/control | grep "Version:" | awk '{print $2}')_$(cat pkg/DEBIAN/control | grep "Architecture:" | awk '{print $2}')"

		sudo rm /etc/mpm/repo/debs/"$(cat pkg/DEBIAN/control | grep "Package:" | awk '{print $2}')"*
		sudo cp ${CONTROL_NAME}.deb /etc/mpm/repo/debs
		cd ..
	done

	echo "Installing '${PKG}'..."
	cd /etc/mpm/repo
	dpkg-scanpackages debs | sudo tee Packages &> /dev/null
	sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/mpm.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0" &> /dev/null
	sudo apt install ${PKG} -y
}

update_pkg() {
	root_check
	REPO_FILES=$(ls /etc/mpm/repo/debs)

	for file in ${REPO_FILES[@]}; do
		CHECK_URL="${URL}rpc.php/rpc/?v=5&type=info&arg=${filename}"

		filename=$(echo ${file} | awk -F"_" '{print $1}')
		filever=$(echo ${file} | awk -F"_" '{print $2}')
		aurver=$(curl -s "${CHECK_URL}" | jq -r '.results[].Version')

		higher_ver=$(echo ${filever} ${aurver} | sed 's/ /\n/g' | sort -V | awk '{print $1}')

		apt list ${filename} 2> /dev/null | grep "\[installed" &> /dev/null
		if [[ ${?} != "0" ]]; then
			sudo rm /etc/mpm/repo/debs/${filename}*.deb
			continue
		fi

		if [[ "${higher_ver}" != "${filever}" ]]; then
			to_update+=" ${filename}"
		fi
	done

	if [[ "${to_update}" == "" ]]; then
		echo "No updates available"
		exit 0
	fi

	echo "Updating AUR packages..."
	ROOT_CONFIRM="FALSE"
	PKG=${to_update}

	install_pkg

}


##################
## BEGIN SCRIPT ##
##################
arg_check ${@}
case ${OP} in
	search)        search_pkg ;;
	install)       install_pkg ;;
	update)        update_pkg ;;
esac
