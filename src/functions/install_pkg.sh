install_pkg() {

	root_check
	PKG=$(echo "${PKG}" | sed 's/ //')

	check_packages
	create_builddir
	aur_clone_files
	arch_repository_clone_files

	echo "Building packages. This may take a bit..."
	aur_build_packages
	arch_repository_build_packages
	install_packages

}
