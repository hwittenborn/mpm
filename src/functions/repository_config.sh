repository_config() {
    if [[ "${1}" == "add" ]]; then
        echo "deb [trusted=yes] file:///etc/mpm/repo /" | sudo tee /etc/apt/sources.list.d/mpm.list &> /dev/null

    elif [[ "${1}" == "remove" ]]; then
        sudo rm /etc/apt/sources.list.d/mpm.list
        sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/mpm.list" \
                            -o Dir::Etc::sourceparts="-" \
                            -o APT::Get::List-Cleanup="0" &> /dev/null

    fi
}
