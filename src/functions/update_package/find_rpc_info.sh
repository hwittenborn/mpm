find_rpc_info() {
    rpc_package="${1}"

    number=0
    result_count="$(echo "${curl_output}" | jq -r .resultcount)"

    while true; do

        if [[ "${number}" -gt "${result_count}" ]]; then
            package_status="not-found"
            break
        fi

        rpc_package_name="$(echo "${curl_output}" | jq -r ".results[$number].Name")"

        if [[ "${rpc_package_name}" == "${rpc_package}" ]]; then
            package_status="found"

            rpc_package_version="$(echo "${curl_output}" | jq -r ".results[$number].Version")"
            break
        fi

        unset rpc_package_name

        number="$(( "${number}" + 1 ))"

    done
}
