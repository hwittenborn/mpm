install_pkg() {
	
	root_check
	PKG=$(echo "${PKG}" | sed 's/ //')

	check_packages
	create_builddir
	clone_files

	build_packages
	install_packages

}
