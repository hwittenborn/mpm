configure_system() {
    if [[ "${1}" == "prepare" ]]; then

        if [[ -d "/var/tmp/mpm/builddir/" || -d "/var/tmp/mpm/debs/" ]]; then
            echo 'Removing old build directory...'
            rm -rf "/var/tmp/mpm/" || { echo "Couldn't remove old build directory."; exit 1; }
        fi

        mkdir -p "/var/tmp/mpm/builddir/" "/var/tmp/mpm/debs/"

        sudo rm -f "/var/tmp/packages-${random_string}.db"
        sudo cp "/var/lib/mpm/packages.db" "/var/tmp/packages-${random_string}.db"

    elif [[ "${1}" == "cleanup" ]]; then
        sudo rm "/var/lib/mpm/packages.db"
        sudo cp "/var/tmp/packages-${random_string}.db" "/var/lib/mpm/packages.db"

    elif [[ "${1}" == "error" ]]; then
        if [[ "${root_status}" == "achieved" ]]; then
            sudo rm -f "/var/tmp/packages-${random_string}.db"
        fi
    fi
}
