generate_results() {
	number="1"

    while [[ "${number}" -le "${resultcount}" ]]; do
        pkgname="$(echo "${curl_output}" | jq -r .results[].Name | awk "NR==${number}")"
        pkgver="$(echo "${curl_output}" | jq -r .results[].Version | awk "NR==${number}")"
        pkgdesc="$(echo "${curl_output}" | jq -r .results[].Description | awk "NR==${number}")"
        maintainer="$(echo "${curl_output}" | jq -r .results[].Maintainer | awk "NR==${number}")"
        numvotes="$(echo "${curl_output}" | jq -r .results[].NumVotes | awk "NR==${number}")"
        outofdate="$(echo "${curl_output}" | jq -r .results[].OutOfDate | awk "NR==${number}")"
        lastmodified="$(echo "${curl_output}" | jq -r .results[].LastModified | awk "NR==${number}")"

        printf "${green_sheet}"
        printf "${pkgname}"

        printf "${normal_sheet}"
        printf "/${pkgver}\n"
        printf "  Description: ${pkgdesc}\n"
        printf "  Maintainer: ${maintainer}\n"
        printf "  Votes: ${numvotes}\n"

        if [[ "${outofdate}" == "null" ]]; then
            printf "  Out Of Date: N/A\n"
        else
            printf "  Out Of Date: ${outofdate}\n"
        fi

        printf "  Last Modified: $(date -d "@${lastmodified}" '+%F')\n"

        printf '\n'

		unset pkgname pkgver pkgdesc maintainer numvotes outofdate lastmodified
		
        number=$(( "${number}" + 1 ))
    done
}
