trap_codes() {
    
    # Cleanup function
    trap_cleanup() {
        if [[ "${OP}" == "install" ]] || [[ "${OP}" == "update" ]]; then
            sudo rm /etc/apt/sources.list.d/mpm.list &> /dev/null
        fi
    }

    # Actual trap codes
    trap "printf 'An unknown error has occurred.\nCleaning up...\n'; trap_cleanup" ERR
    trap "printf 'Aborted by user.\nCleaning up...\n'; trap_cleanup" INT
}
