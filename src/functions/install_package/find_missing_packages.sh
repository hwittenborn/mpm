find_missing_packages() {
    package_list="$(echo "${curl_output}" | jq -r .results[].Name)"

    for i in ${packages}; do
        if [[ "$(echo "${package_list}" | grep "^${i}$")" == "" ]]; then
            unknown_packages+="${i} "
        fi
    done
}
