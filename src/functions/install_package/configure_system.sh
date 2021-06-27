configure_system() {
    if [[ "${1}" == "prepare" ]]; then
        sudo rm -f "/var/tmp/sources-${random_string}.db"
        sudo cp "/var/lib/mpm/packages.db" "/var/tmp/sources-${random_string}.db"
        echo "deb [trusted=yes] file:///var/lib/mpm/repo/" | sudo tee "/etc/apt/sources.list.d/${random_string}.list" &> /dev/null

    elif [[ "${1}" == "cleanup" ]]; then
        sudo rm "/var/lib/mpm/packages.db"
        sudo cp "/var/tmp/sources-${random_string}.db" "/var/lib/mpm/packages.db"
        sudo rm "/etc/apt/sources.list.d/${random_string}.list"
    fi
}
