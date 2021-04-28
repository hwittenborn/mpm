search_pkg() {

	PKG=$(echo "${PKG}" | sed 's/ //')

	echo "Searching for '${PKG}'..."

	URL="${URL}rpc.php/rpc/?v=5&type=search&arg=${PKG}"
	RESULTS=$(curl -s "${URL}" | jq)

	if [[ $(echo ${RESULTS} | jq -r '.resultcount') == "0" ]]; then
		echo "No results"
		exit 0
	elif [[ $(echo ${RESULTS} | jq -r '.resultcount') > "50" ]]; then
		echo "Large amount of results detected. This might take a bit..."
	fi

	PKGNUM="1"
	if [[ ${LIST_PER_PACKAGE} == "FALSE" ]]; then
		echo "$(print_results)"
	else
		print_results
	fi

}
