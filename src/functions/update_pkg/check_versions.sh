check_versions() {
    # Read database, and set 'number' used for awk to read each line
    local sources_db_content=$(cat /etc/mpm/sources.db)
    local number="1"

    # Start loop of each package in database
    for i in $(echo "${sources_db_content}" | awk -F '\' '{print $1}'); do

        # Check if package is from AUR
        export sources_db_package_source="$(echo "${sources_db_content}" | awk -F '\' '{print $3}' | awk NR==${number})"
        if [[ "${sources_db_package_source}" == "aur" || "${sources_db_package_source}" == "aur_dependency" ]]; then

            # Check local version of package
            local pkg_local_version=$(echo "${sources_db_content}" | awk -F '\' '{print $2}' | awk NR==${number})

            # Check version of package in AUR
            local pkg_aur_version=$(curl -s "${aur_url}rpc.php/rpc/?v=5&type=info&arg=${i}" | jq .results[].Version)

            # Tried doing this in an if statement, never got it to work 100% of the time. So now we do this (lucky subshells :c)
            if ! printf "${pkg_local_version}\n${pkg_aur_version}" | sort -V | awk NR==2 | grep "${pkg_local_version}" &> /dev/null ; then
                to_update+=" ${i}"
            fi

        # Check if package is from the Arch Linux repositories
        elif [[ "${sources_db_package_source}" == "arch_repository" || "${sources_db_package_source}" == "arch_dependency" ]]; then

            # Check local version of package
            local pkg_local_version=$(echo "${sources_db_content}" | awk -F '\' '{print $2}' | awk NR==${number})

            # Check version of package in Arch Linux repositories
            local pkg_arch_repository_results=$(curl -s "${arch_repository_search_url}${i}")

                # Get epoch, pkgver, and pkgrel
                local pkg_arch_repository_epoch=$(echo ${pkg_arch_repository_results} | jq .results[].epoch)
                local pkg_arch_repository_pkgver=$(echo ${pkg_arch_repository_results} | jq .results[].pkgver)
                local pkg_arch_repository_pkgrel=$(echo ${pkg_arch_repository_results} | jq .results[].pkgrel)

                # Add epoch if greater than 1
                if [[ "${epoch}" -gt "1" ]]; then
                    pkg_arch_repository_epoch_status="${epoch}:"
                fi

                # Set Arch Linux repository version
                pkg_arch_repository_version="${pkg_arch_repository_epoch_status}${pkgver}-${pkgrel}"

            # Tried doing this in an if statement, never got it to work 100% of the time. So now we do this (lucky subshells :c)
            if ! printf "${pkg_local_version}\n${pkg_arch_repository_version}" | sort -V | awk NR==2 | grep "${pkg_local_version}" &> /dev/null ; then
                to_update+=" ${i}"
            fi
        fi

        # Restart loop with $number set to one higher
        number=$(( ${number} + 1 ))
    done

    # Set packages that need to be updated, then run 'xargs' to fix spacing
    to_update=$(echo ${to_update} | xargs)
}
