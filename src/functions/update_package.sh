update_package() {
    package_list="$(dpkg-query --show --showformat '${Package}/${MPR-Package}/${Version}\n' |
                    grep '^[^/]*/[^/]')"

    package_names="$(echo "${package_list}" | awk -F '/' '{print $2}')"

    for i in ${package_names}; do
        request_arguments+="&arg[]=${i}"
    done

    curl_output="$(curl -sH "User-Agent: mpm/${mpm_version}" "https://${dur_url}/rpc/?v=5&type=info${request_arguments}")"

    if ! echo "${curl_output}" | jq &> /dev/null; then
        echo "[update_package] There was an error processing your request."
        exit 1
    fi

    unset request_arguments

    for i in ${package_list}; do
        local_package_name="$(echo "${i}" | awk -F '/' '{print $2}')"
        local_package_version="$(echo "${i}" | awk -F '/' '{print $3}')"

        find_rpc_info "${local_package_name}"

        if [[ "${package_status}" == "not-found" ]]; then
            continue
        fi

        if [[ "${local_package_version}" != "${rpc_package_version}" ]]; then
            packages_to_update+=("${local_package_name}")
        fi
    done

    if [[ "${packages_to_update}" == "" ]]; then
        echo "Your system is up to date."
        exit 1
    fi

    unset packages
    export packages="$(echo "${packages_to_update[@]}" | sed 's| |\n|g' | sort -u | xargs)"

    install_package
}
