search_pkg() {

	search_query=$(echo "${PKG}" | sed 's/ //')

	aur_search_url="${aur_url}rpc.php/rpc/?v=5&type=search&arg=${search_query}"
	aur_search_results=$(curl -s -H "User-Agent: mpm/${mpm_version}" "${aur_search_url}" | jq)
	arch_repository_search_results=$(curl -s -H "User-Agent: mpm/${mpm_version}" "${arch_repository_search_url}${search_query}")

	if [[ $(echo ${aur_search_results} | jq -r '.resultcount') == "0" ]] && \
	   [[ $(echo ${arch_repository_search_results} | \
		      grep pkgname | \
					sed 's|"||g' | \
					sed 's|pkgname: ||g' | \
					sed 's|,||g' | \
					sed 's| ||g' | \
					wc -w) == "0" ]]; then
		echo "No results"
		exit 0
	elif [[ $(( $(echo ${aur_search_results} | jq -r '.resultcount') + \
							$(echo ${arch_repository_search_results} | \
							   grep pkgname | \
								 sed 's|"||g' | \
								 sed 's|pkgname: ||g' | \
								 sed 's|,||g' | \
								 sed 's| ||g' | \
								 wc -w) )) -gt "25" ]]; then
		echo "Large amount of results detected. This might take a bit..."
	fi

	if [[ ${LIST_PER_PACKAGE} != "true" ]]; then
		echo "$(get_results)"
	else
		get_results
	fi

}
