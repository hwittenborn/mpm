install_pkg() {
	root_check
	get_root

	PKG=$(echo "${PKG}" | sed 's/ //')

	create_builddir
	check_build_sources
	clone_build_files

	[[ "${SKIP_PKGBUILD_CHECK}" == "TRUE" ]] || aur_check_files

	echo "Building packages. This may take a bit..."
	aur_build_packages
	arch_repository_build_packages
	install_packages

}
