dependency_checks() {
    number=0
    for i in ${packages}; do
        # 1. echo JSON results
        # 2. Print the results for the relevant package
        # 3. Remove 'null' if present
        # 4. Put all on one line
        dependencies_temp+="$(echo "${curl_output}" | jq -r ".results[$number].Depends[]" 2> /dev/null | grep -v 'null' | xargs)"
        make_dependencies_temp+="$(echo "${curl_output}" | jq -r ".results[$number].MakeDepends[]" 2> /dev/null | grep -v 'null' | xargs)"
        check_dependencies_temp+="$(echo "${curl_output}" | jq -r ".results[$number].CheckDepends[]" 2> /dev/null | grep -v 'null' | xargs)"

        number="$(( ${number} + 1 ))"
    done

    dependencies="$(echo "${dependencies_temp}" | sed 's| |\n|g' | sort -u | xargs)"
    make_dependencies="$(echo "${make_dependencies_temp}" | sed 's| |\n|g' | sort -u | xargs)"
    check_dependencies="$(echo "${check_dependencies_temp}" | sed 's| |\n|g' | sort -u | xargs)"

    unset dependencies_temp make_dependencies_temp check_dependencies_temp

    # Remove dependency relationships (<<, <=, =, >=, >>) from list for checking
    # with APT, as APT doesn't allow using those descriptors.
    dependency_list="$(echo "${dependencies}" "${make_dependencies}" "${check_dependencies}" | sed 's| |\n|g' | sed -E 's/>.*|<.*|=.*//g' | xargs)"

    apt_output="$(apt list ${dependency_list} 2> /dev/null | grep -E "${system_architecture}|all")"

    for i in ${dependencies}; do
        package_name="$(echo "${i}" | grep -o '^[^>]*' | grep -o '^[^<]*' | grep -o '^[^=]*')"

        relationship_string="$(echo "${i}" | grep -Eo '<.*|>.*|=.*')"
        relationship_type="$(echo "${relationship_string}" | grep -Eo '<<|<=|=|>=|>>')"
        relationship_version="$(echo "${relationship_string}" | sed -E 's/<<|<=|=|>=|>>//g')"

        apt_found_package="$(echo "${apt_output}" | grep -Eo "^${i}[^/]*")"
        apt_package_version="$(echo "${apt_found_package}" | awk '{print $2}')"

        # Check if package can be found
        if [[ "${apt_found_package}" == "" ]]; then
            apt_bad_packages+=" ${i}"
            continue

        # Check if relationship_type is empty. We can just start the next loop
        # if it is, as that means the package is available (see prev. check),
        # and there was no version to check against.
        elif [[ "${relationship_type}" == "" ]]; then
            continue

        else

            if [[ "${relationship_type}" == '<<' ]]; then
                apt_relationship_type='-lt'
            elif [[ "${relationship_type}" == '<=' ]]; then
                apt_relationship_type='-le'
            elif [[ "${relationship_type}" == '=' ]]; then
                apt_relationship_type='-eq'
            elif [[ "${relationship_type}" == '>=' ]]; then
                apt_relationship_type='-ge'
            elif [[ "${relationship_type}" == '>>' ]]; then
                apt_relationship_type='gt'
            fi

            if ! /usr/bin/test "${apt_package_version}" "${apt_relationship_type}" "${relationship_version}"; then
                apt_bad_package+=" ${i}"
            fi
        fi
    done
}
