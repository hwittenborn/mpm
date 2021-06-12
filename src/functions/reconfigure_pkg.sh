reconfigure_pkg() {
    export source_db_data="$(cat /etc/mpm/sources.db)"
    export argument=(${PKG})

    echo "WARNING: You are about to perform operations directly on the mpm database."
    echo "Incorrect usage could potentially lead to mpm ceasing to work properly."
    echo
    read -p "Do you want to continue? [y/N] " confirm_status_temp
    export confirm_status="${confirm_status_temp,,}"

    if [[ "${confirm_status,,:-n}" != "y" ]]; then
        echo "Quitting..."
        exit 1
    fi

    if [[ "${argument[1]}" == "" || "${argument[2]}" == "" || "${argument[3]}" != "" ]]; then
        echo "Incorrect amount of values were provided."
        echo "Aborting..."
        exit 1
    fi

    if ! cat /etc/mpm/sources.db | grep "^${argument[0]}\\\\" &> /dev/null; then
        echo "Couldn't find ${argument[0]} in the database."
        exit 1
    fi

    if [[ "${argument[1]}" == "version" ]]; then
        echo "Setting version of ${argument[0]} to ${argument[2]}..."

        export db_source="$(echo "${source_db_data}" | grep "^${argument[0]}\\\\" | awk -F '\' '{print $3}')"
        sudo sed -i "s|^${argument[0]}\\\\.*|${argument[0]}\\\\${argument[2]}\\\\${db_source}|" /etc/mpm/sources.db

    elif [[ "${argument[1]}" == "source" ]]; then
        echo "Setting source of ${argument[0]} to ${argument[2]}..."

        export db_version="$(echo "${source_db_data}" | grep "^${argument[0]}\\\\" | awk -F '\' '{print $3}')"
        sudo sed -i "s|^${argument[0]}\\\\.*|${argument[0]}\\\\${db_version}\\\\${argument[2]}|" /etc/mpm/sources.db

    else
        echo "Unknown option '${argument[1]}'."
        exit 1
    fi
}
