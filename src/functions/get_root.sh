get_root() {
    if [[ "$(whoami)" == "root" ]]; then
        echo "Running mpm as root is currently disabled. Please run mpm as a normal user, and mpm will prompt for permissions when needed."
    fi

    echo "Obtaining root permissions..."
    if ! sudo true; then
        echo "Couldn't obtain root permissions. Aborting."
        exit 1
    fi

    root_status="achieved"
}
