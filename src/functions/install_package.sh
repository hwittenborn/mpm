install_package() {
    for i in ${packages}; do
        export dur_package_args+="&arg[]=${i}"
    done

    export curl_output="$(curl -s "https://${dur_url}/rpc/?v=5&type=info${dur_package_args}")"

    if ! echo "${curl_output}" | jq &> /dev/null; then
        printf "There was an error processing your request.\n"
        exit 1
    fi

    resultcount="$(echo "${curl_output}" | jq -r .resultcount)"
    num_of_packages="$(echo ${packages} | wc -w)"

    if [[ "${num_of_packages}" != "${resultcount}" ]]; then
        find_missing_packages
        printf "Couldn't find the following packages: $(echo "${unknown_packages}" | xargs | sed 's| |, |g')\n"
        exit 1
    fi

    if [[ -d "/var/tmp/${USER}/mpm/" ]]; then
        rm -rf "/var/tmp/${USER}/mpm/" || { printf "Couldn't remove old build directory.\n"; exit 1; }
    fi

    mkdir -p "/var/tmp/${USER}/mpm/"
    cd "/var/tmp/${USER}/mpm/"

    printf "Checking package dependencies..."
    dependency_checks &
    process_id="$!"
    spinner
    unset process_id

    if [[ "${apt_bad_package}" != "" ]]; then
        echo "The following dependencies are unable to be installed:"
        echo "  $(echo "${apt_bad_package}" | xargs | sed 's| |, |g')"
    fi

    if [[ "${dependency_list}" != "" ]]; then
        echo "The following additional packages are going to be installed:"
        echo "  ${dependency_list}"
        echo "The following packages are going to be installed:"
        echo "  ${packages} ${dependency_list}"
    else
        echo "The following packages are going to be installed:"
        echo "  ${packages}"
    fi

    echo
    read -p "Do you want to continue? [Y/n] " continue_status
    if [[ "${continue_status,,}" == "n" ]]; then
        echo "Quitting..."
        exit 1
    fi
    unset continue_status

    printf "Cloning packages..."
    clone_packages() {
        for i in ${packages}; do
            git clone "https://${dur_url}/${i}.git" &> /dev/null
        done
    }
    clone_packages &
    process_id="$!"
    spinner
    unset process_id

    for i in ${packages}; do
        read -p "Look over files for '${i}'? [Y/n] " continue_status

        while [[ "${continue_status,,}" != "n" ]]; do
            nano $(find ${i} -type f | grep -Ev '.git|.SRCINFO')
            sleep 1

            read -p "Look over files for '${i}'? [Y/n] " continue_status
        done

        echo
    done

    echo "Installing dependencies..."
    sudo apt install ${dependency_list}
    sudo apt-mark auto ${dependency_list}

    if [[ "${?}" != "0" ]]; then
        echo "There was an error installing the dependencies."
        echo "Quitting..."
    fi

    echo "Building packages..."

    number=0
    for i in ${packages}; do
        cd "${i}"

        package_version="$(echo "${curl_output}" | jq ".results[$number].Version")"
        source PKGBUILD
        ( makedeb -v )

        for j in ${pkgname}; do
            sudo cp "${j}_${package_version}_${system_architecture}.deb" "/var/lib/mpm/repo/debs/"
        done

        package_db add "${i}" "${package_version}"

        cd ..
    done

    echo "Installing packages..."
    sudo apt install ${packages} -o "Dir::Etc::sourcelist=sources.list.d/${random_string}.list" \
                                 -o "Dir::Etc:sourceparts=-" \
                                 -o "APT::Get::List-Cleanup=0"

    echo "Done."
}
