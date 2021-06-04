trap_codes() {

    # Cleanup function
    trap_cleanup() {
        if [[ "${OP}" == "install" ]] || [[ "${OP}" == "update" ]]; then

            echo "Cleaning up..."
            if [[ "${arg_dryrun}" != "true" ]]; then
                sudo rm /etc/apt/sources.list.d/mpm.list &> /dev/null
            fi
        fi
    }

    # Check exit code for first trap code
    trap_code_check() {
        if [[ "${?}" != "0" ]]; then
            echo "An unknown error has occurred."
            trap_cleanup
            exit 1
        fi
    }

    # Actual trap codes
    trap '[[ "${trap_int}" != "true" ]] && trap_code_check' EXIT
    trap "export trap_int=true; echo Aborted by user.; trap_cleanup" INT
}
