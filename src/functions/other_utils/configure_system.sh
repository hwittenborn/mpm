configure_system() {
    if [[ "${1}" == "prepare" ]]; then

        if [[ -d "/var/tmp/mpm/builddir/" || -d "/var/tmp/mpm/debs/" ]]; then
            echo 'Removing old build directory...'
            rm -rf "/var/tmp/mpm/" || { echo "Couldn't remove old build directory."; exit 1; }
        fi

        mkdir -p "/var/tmp/mpm/builddir/" "/var/tmp/mpm/debs/"
        
    fi
}
