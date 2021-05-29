install_pkg() {
	root_check
	get_root

	PKG=$(echo "${PKG}" | xargs)

	create_builddir

  check_aur_dependencies
	check_arch_dependencies

	check_build_sources
	[[ "${apt_uptodate_message}" != "" ]] && printf "${apt_uptodate_message}"
	[[ "${aur_packages}" == "" ]] && [[ "${arch_repository_packages}" == "" ]] && exit 2

	if [[ "${aur_depends}" != "" ]] || [[ "${arch_depends}" != "" ]]; then
		echo "The following additional packages are going to be installed:"
		echo "  $(echo ${aur_depends} ${arch_depends} | xargs)"
		echo
	fi

	echo "The following packages are going to be installed:"
	echo "  ${aur_packages} ${arch_packages} ${aur_depends} ${arch_depends}"
	echo
	read -p "Continue (Y/n)?" continue_status

	[[ "${continue_status}" != "Y" ]] && exit 1

	clone_build_files

	[[ "${SKIP_PKGBUILD_CHECK}" == "TRUE" ]] || aur_check_files

	echo "Building packages. This may take a bit..."
	build_dependency_packages
	build_aur_packages
	build_arch_packages

	echo "Installing packages..."
	install_packages
}
