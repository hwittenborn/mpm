arg_check() {
    case ${1} in
        ""|-h|--help)      printf "$(show_help)\n" ;;
        search)            export operation="search" ;;
        install)           export operation="install" ;;
        update|upgrade)    export operation="update" ;;
        *)                 echo "Unknown command '${1}'. See the list of available commands with 'mpm --help'." ;;
    esac
    shift 1

    while [[ "${1}" != "" ]]; do
        case ${1} in
            -h|--help)     show_help ;;
            -*)            echo "Unknown option '${1}'. See the list of available options with 'mpm --help'." ;;
            *)             packages_temp+="${1} " ;;
        esac

        shift 1
    done

    # Post checks
    export packages="$(echo "${packages_temp}" | sed 's| |\n|g' | sort -u | xargs)"

    if [[ "${operation}" == "update" && "${packages}" != "" ]]; then
        echo "Packages can't be specified when using the update option."
        exit 1
    fi
}
