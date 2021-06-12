install_pkg() {
	root_check
	[[ "${arg_dryrun}" != "true" ]] && get_root

	PKG=$(echo "${PKG}" | xargs)

	create_builddir

    check_aur_dependencies
	check_arch_dependencies

	check_build_sources
	[[ "${apt_uptodate_message}" != "" ]] && printf "${apt_uptodate_message}"
	[[ "${aur_packages}" == "" ]] && [[ "${arch_repository_packages}" == "" ]] && exit 2

    # We only want to notify the user of packages that are going to be built
    # when 'install' is specified, as update_pkg() notifies users on what
    # packages are going to be upgraded.
    if [[ "${OP}" != "update" ]]; then

        if [[ "${aur_dependency_packages}" != "" ]] || [[ "${arch_dependency_packages}" != "" ]]; then
            echo "The following additional packages are going to be built:"
            echo ${aur_dependency_packages} ${arch_dependency_packages} | sed 's|^|  |'
            echo
        fi

        echo "The following packages are going to be built:"
        echo ${aur_packages} ${arch_repository_packages} ${aur_dependency_packages} ${arch_dependency_packages} | sed 's|^|  |'
        echo
        read -p "Do you want to continue? [Y/n] " continue_status

        [[ "${continue_status:-Y}" != "Y" ]] && exit 1
    fi

    # Prepare system for building
    echo "Preparing..."
    export sources_db_backup="sources-${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}.db"
    sudo cp /etc/mpm/sources.db "/tmp/${sources_db_backup}"
    [[ "${arg_dryrun}" != "true" ]] && repository_config add

	clone_build_files

	[[ "${SKIP_PKGBUILD_CHECK}" == "TRUE" ]] || aur_check_files

	echo "Building packages. This may take a bit..."
	build_aur_dependencies
    build_arch_dependencies

	build_aur_packages
	build_arch_packages

	if [[ "${arg_dryrun}" != "true" ]]; then
        echo "Installing packages..."
        install_packages
    fi

    # Post-build cleanup
    echo "Cleaning up..."
    [[ "${arg_dryrun}" != "true" ]] && repository_config remove
}
