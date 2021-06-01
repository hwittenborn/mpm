repository_config() {
    if [[ "${1}" == "add" ]]; then
        echo "deb [trusted=yes] file:///etc/mpm/repo /" | sudo tee /etc/apt/sources.list.d/mpm.list &> /dev/null
    elif [[ "${1}" == "remove" ]]; then
        rm /etc/apt/sources.list.d/mpm.list
    fi
}
