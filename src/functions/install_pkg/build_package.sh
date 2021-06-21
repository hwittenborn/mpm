build_package() {
    # Build package
    cd "${1}"
    source PKGBUILD
    makedeb --convert --syncdeps --pkgname  "${1}" ${makedeb_options}

    # Run if the dryrun argument wasn't passed
    if [[ "${arg_dryrun}" != "true" ]]; then

        # Copy package to local repository
        sudo rm /etc/mpm/repo/debs/"${1}"*.deb &> /dev/null || printf ""
        sudo cp "${1}"_"$(version_gen)"_*.deb /etc/mpm/repo/debs/

        # Add package to database
        # 1. First pair of backslashes goes to shell - results in three
        # 2. One in the pair of three gets interpreted by the shell in sed command - results in 2
        # 3. Last pair is interpreted by sed - results in 1
        local export_to_database=$(echo "${1}\\\\\\$(version_gen)\\\\\\${2}")

        # Runs if package exists in database - replaces package entry in database
        if cat /etc/mpm/sources.db | awk -F '\' '{print $1}' | grep "${1}" &> /dev/null; then
            sudo sed -i "s|^${1}\\.*|${export_to_database}|" /etc/mpm/sources.db

            # Runs every other time - adds package entry to database
        else
            echo "${export_to_database}" | sudo tee -a /etc/mpm/sources.db &> /dev/null
        fi

    fi

    cd ..
}
