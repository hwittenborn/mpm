trap_codes() {
    trap_int() {
        echo "Aborted by user. Cleaning up..."
        configure_system error &> /dev/null

        exit 1
    }

    trap_err() {
        echo "An unknown error has occured. Cleaning up..."
        configure_system error &> /dev/null

    }

    trap 'trap_int' SIGINT
    trap 'trap_err' ERR
}
