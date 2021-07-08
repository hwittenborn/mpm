search_package() {
    curl_output="$(curl -sH "User-Agent: mpm/${mpm_version}" "https://${dur_url}/rpc/?v=5&type=search&arg=${packages}")"

    if ! echo "${curl_output}" | jq &> /dev/null; then
        echo "There was an error processing the request."
        exit 1
    fi

    resultcount="$(echo "${curl_output}" | jq .resultcount)"

    if [[ "${resultcount}" == "0" ]]; then
        echo "No results."
        exit 1
    fi

    generate_results | head -c -1
}
