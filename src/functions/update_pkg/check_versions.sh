check_versions() {
    # Read database, and set 'number' used for awk to read each line
    local sources_db_content=$(cat /etc/mpm/sources.db)
    local number="1"

    # Start loop of each package in database
    for i in $(echo "${sources_db_content}" | awk -F '\' '{print $1}'); do

        # Check if package is from AUR
        if [[ $(echo "${sources_db_content}" | awk -F '\' '{print $3}' | awk NR==${number}) == "aur" ]]; then

            # Check local version of package
            local pkg_local_version=$(echo "${sources_db_content}" | awk -F '\' '{print $2}' | awk NR==${number})

            # Check version of package in AUR
            local pkg_aur_version=$(curl -s "${aur_url}rpc.php/rpc/?v=5&type=info&arg=${i}" | jq .results[].Version)

            # Check which version is highest
            local pkg_highest_version=$(echo ${pkg_local_version} ${pkg_aur_version} | sort -V | awk '{print $2}')

            if [[ ${pkg_highest_version} != ${pkg_local_version} ]]; then
                to_update+=" ${i}"
            fi

        # Check if package is from the Arch Linux repositories
        elif [[ $(echo "${sources_db_content}" | awk -F '\' '{print $3}' | awk NR==${number}) == "arch_repository" ]]; then

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

            # Check which version is highest
            local pkg_highest_version=$(echo ${pkg_local_version} ${pkg_arch_repository_version} | sort -V | awk '{print $2}')

            if [[ ${pkg_highest_version} != ${pkg_local_version} ]]; then
                to_update+=" ${i}"
            fi
        fi

        # Restart loop with $number set to one higher
        number=$(( ${number} + 1 ))
    done

    # Set packages that need to be updated, then run 'xargs' to fix spacing
    to_update=$(echo ${to_update} | xargs)
}
