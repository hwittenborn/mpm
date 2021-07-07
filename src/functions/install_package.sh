install_package() {
    for i in ${packages}; do
        export dur_package_args+="&arg[]=${i}"
    done

    export curl_output="$(curl -sH "User-Agent: mpm/${mpm_version}" "https://${dur_url}/rpc/?v=5&type=info${dur_package_args}")"

    if ! echo "${curl_output}" | jq &> /dev/null; then
        echo "[install_package] There was an error processing your request."
        exit 1
    fi

    resultcount="$(echo "${curl_output}" | jq -r .resultcount)"
    num_of_packages="$(echo ${packages} | wc -w)"

    if [[ "${num_of_packages}" != "${resultcount}" ]]; then
        find_missing_packages
        echo "Couldn't find the following packages: $(echo "${unknown_packages}" | xargs | sed 's| |, |g')\n"
        exit 1
    fi

    echo "Checking build dependencies..."
    dependency_checks

    echo

    if [[ "${apt_needed_dependencies}" != "" ]]; then
        echo "The following additional packages are going to be installed:"
        echo " ${apt_needed_dependencies}"
        echo "The following packages are going to be built:"
        echo "  ${packages}"
        echo "The following packages are going to be ${operation_string}:"
        echo "  ${packages} ${apt_needed_dependencies}"
    else
        echo "The following packages are going to be built and ${operation_string}:"
        echo "  ${packages}"
    fi

    echo
    read -p "Do you want to continue? [Y/n] " continue_status
    if [[ "${continue_status,,}" == "n" ]]; then
        echo "Quitting..."
        exit 1
    fi
    unset continue_status

    echo "Preparing..."
    configure_system prepare
    cd "/var/tmp/mpm/builddir/"

    echo "Cloning packages..."
    for i in ${packages}; do
        git clone "https://${dur_url}/${i}.git" &> /dev/null
    done

    for i in ${packages}; do
        read -p "Look over files for '${i}'? [Y/n] " continue_status

        while [[ "${continue_status,,}" != "n" ]]; do
            nano $(find ${i} -type f | grep -Ev '.git|.SRCINFO')
            sleep 1

            read -p "Look over files for '${i}'? [Y/n] " continue_status
        done

        echo
    done

    if [[ "${apt_needed_dependencies}" != "" ]]; then
        echo "Installing dependencies..."
        sudo apt install ${apt_needed_dependencies}
        apt_exit_code="${?}"

        sudo apt-mark auto ${apt_needed_dependencies} &> /dev/null

        if [[ "${apt_exit_code}" != "0" ]]; then
            echo "There was an error installing build dependencies."
            echo "Quitting..."
            exit 1
        fi

    fi
    unset apt_exit_code

    echo "Building packages..."

    number=0
    for i in ${packages}; do
        cd "${i}"

        package_version="$(echo "${curl_output}" | jq -r ".results[$number].Version")"
        source PKGBUILD

        if [[ "${arch}" == "any" ]]; then
            system_architecture="all"
        fi

        check_for_mpr_control_field

        if [[ "${mpr_package_field}" == "true" ]]; then
            makedeb -v
        else
            makedeb -vH "MPR-Package: ${i}"
        fi

        for j in ${pkgname}; do
            sudo cp "${j}_${package_version}_${system_architecture}.deb" "/var/tmp/mpm/debs/"
        done

        cd ..
    done

    echo "Installing packages..."
    echo
    cd /var/tmp/mpm/debs/
    sudo apt install ./*.deb
    echo
    echo "Done."
}
