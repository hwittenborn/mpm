clone_package() {
	for i in ${packages}; do
		export dur_package_args+="&arg[]=${i}"
	done

	# Make sure packages exist
	export curl_output="$(curl -sH "User-Agent: mpm/${mpm_version}" "https://${dur_url}/rpc/?v=5&type=info${dur_package_args}")"

	if ! echo "${curl_output}" | jq &> /dev/null; then
		echo "[install_package] There was an error processing your request."
		exit 1
	fi

	clone_package_list="$(echo "${curl_output}" | jq -r '.results[].Name')"

	for i in ${packages}; do
		if [[ "$(echo "${clone_package_list}" | grep "^${i}\$")" == "" ]]; then
			clone_bad_packages+=("${i}")
		fi
	done

	if [[ "${clone_bad_packages}" != "" ]]; then
		echo "Couldn't find the following packages:"
		echo "  ${clone_bad_packages[@]}"
		exit 1
	fi

	# Make sure clone directory exists when specified
	if [[ "${clone_directory}" != "" ]]; then

		if ! [[ -d "${clone_directory}" ]]; then
			echo "Creating directory '${clone_directory}'..."
			mkdir "${clone_directory}" ${mkdir_parents_argument}
		fi

		cd "${clone_directory}"
	fi

	# Used for error logs below
	clone_random_string="${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}"

	while [ -f "/var/tmp/mpm-clone-${clone_random_string}.log" ]; do
		clone_random_string="${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}"
	done

	# Start package cloning
	for i in ${packages}; do

		if [[ -d "${i}" ]]; then
			echo "Directory '${i}' already exists. Skipping..."
			continue
		fi

		# We entered into the clone directory (if specified) a bit above, and
		# the following output is thus simply decorative.
		if [[ "${clone_directory}" == "" ]]; then
			echo "Cloning '${i}'..."
		else
			echo "Cloning '${i}' into '${clone_directory}'..."
		fi

		git clone "https://${dur_url}/${i}.git" &>> "/var/tmp/mpm-clone-${clone_random_string}.log"

		if [[ "${?}" != "0" ]]; then
			clone_error_packages+=("${i}")
		fi

	done

	if [[ "${clone_error}" == "true" ]]; then
		echo "There was an error cloning the following packages:"
		echo "  ${clone_error_packages[@]}"
		echo "See '/var/tmp/mpm-clone-${clone_random_string}.log' for more info."
		exit 1
	fi

	rm "/var/tmp/mpm-clone-${clone_random_string}.log"
}
