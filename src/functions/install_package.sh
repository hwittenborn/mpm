install_package() {
    for i in ${packages}; do
        export dur_package_args+="&arg[]=${i}"
    done

    export curl_output="$(curl -s "https://${dur_url}/rpc/?v=5&type=info${dur_package_args}")"

    if ! echo "${curl_output}" | jq &> /dev/null; then
        echo "There was an error processing your request."
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
    if [[ "${apt_bad_package}" != "" ]]; then
        echo "The following build packages have unmet dependencies:"
        echo "  $(echo "${apt_bad_package}" | xargs | sed 's| |, |g')"
    fi

    if [[ "${dependency_install_list}" != "" ]]; then
        echo "The following additional packages are going to be installed:"
        echo " ${dependency_install_list}"
        echo "The following packages are going to be installed:"
        echo "  ${packages}${dependency_install_list}"
    else
        echo "The following packages are going to be installed:"
        echo "  ${packages}"
    fi

    echo
    read -p "Do you want to continue? [Y/n] " continue_status
    if [[ "${aborting_now}" != "true" &&  "${continue_status,,}" == "n" ]]; then
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

    if [[ "${dependency_install_list}" != "" ]]; then
        echo "Installing dependencies..."
        sudo apt install ${dependency_list}
        sudo apt-mark auto ${dependency_list}
    fi

    if [[ "${?}" != "0" ]]; then
        echo "There was an error installing the dependencies."
        echo "Quitting..."
    fi

    echo "Building packages..."

    number=0
    for i in ${packages}; do
        cd "${i}"

        package_version="$(echo "${curl_output}" | jq -r ".results[$number].Version")"
        source PKGBUILD

        if [[ "${arch}" == "any" ]]; then
            system_architecture="all"
        fi

        makedeb -v

        for j in ${pkgname}; do
            sudo cp "${j}_${package_version}_${system_architecture}.deb" "/var/tmp/mpm/debs/"
        done

        package_db add "${i}" "${package_version}"

        cd ..
    done

    echo "Installing packages..."
    echo
    cd /var/tmp/mpm/debs/
    sudo apt install ./*.deb
    echo

    echo "Cleaning up..."
    configure_system cleanup

    echo "Done."
}
