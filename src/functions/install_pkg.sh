install_pkg() {
	root_check
	get_root

	PKG=$(echo "${PKG}" | xargs)

	create_builddir
	check_arch_dependencies
	check_build_sources
	clone_build_files

	[[ "${SKIP_PKGBUILD_CHECK}" == "TRUE" ]] || aur_check_files

	echo "Building packages. This may take a bit..."
	build_dependency_packages
	build_aur_packages
	build_arch_packages

	echo "Installing packages..."
	install_packages
}
