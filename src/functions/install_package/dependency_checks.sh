dependency_checks() {
    number=0
    for i in ${packages}; do
        # 1. echo JSON results
        # 2. Print the results for the relevant package
        # 3. Remove 'null' if present
        # 4. Put all on one line
        dependencies_temp+=($(echo "${curl_output}" | jq -r ".results[$number].Depends[]" 2> /dev/null | grep -v 'null' | xargs))
        make_dependencies_temp+=($(echo "${curl_output}" | jq -r ".results[$number].MakeDepends[]" 2> /dev/null | grep -v 'null' | xargs))
        check_dependencies_temp+=($(echo "${curl_output}" | jq -r ".results[$number].CheckDepends[]" 2> /dev/null | grep -v 'null' | xargs))

        number="$(( ${number} + 1 ))"
    done

    dependency_packages="$(echo "${dependencies_temp}" "${make_dependencies_temp}" "${check_dependencies_temp}" | sed 's| |\n|g' | sort -u | xargs)"
    unset dependencies_temp make_dependencies_temp check_dependencies_temp

	if [[ "${dependency_packages}" != "" ]]; then

		for i in ${dependency_packages}; do
        	generate_package_parenthesis "${i}"
    	done

    	apt_output="$(eval apt-get satisfy -sq ${apt_packages[@]})"

    	apt_bad_packages="$(echo "${apt_output}" | grep -o '[^ ]* but it is not installable' | sed 's| but it is not installable||')"

    	if [[ "${apt_bad_packages}" != "" ]]; then
        	echo "The following build dependencies are unable to be installed:"
        	echo "  ${apt_bad_packages}"
        	exit 1
    	fi

    	unset apt_bad_packages

    	# This gets used back in install_package() to list both build dependencies
    	# *and* packages to be built
    	apt_needed_dependencies="$(echo "${apt_output}" |
                                   sed 's|$| |g' |
                                   tr -d '\n' |
                                   grep -o 'The following NEW packages will be installed:.*[[:digit:]] upgraded' |
                                   sed 's|The following NEW packages will be installed:||' |
                                   sed 's|[[:digit:]] upgraded||' |
                                   xargs)" || true
    fi
}
