arg_check() {
    case ${1} in
        ""|-h|--help)      show_help; exit 0 ;;
        search)            export operation="search" ;;
        install)           export operation="install"; export operation_string="installed" ;;
        update|upgrade)    export operation="update"; export operation_string="upgraded" ;;
        *)                 echo "Unknown command '${1}'. See the list of available commands with 'mpm --help'." ;;
    esac
    shift 1 || true

    while [[ "${1}" != "" ]]; do
        case ${1} in
            -h|--help)     show_help ;;
            --verbose)     set -x ;;
            -*)            echo "Unknown option '${1}'. See the list of available options with 'mpm --help'." ;;
            *)             packages_temp+="${1} " ;;
        esac

        shift 1 || true
    done

    # Post-argument checks
    declare packages="$(echo "${packages_temp}" | sed 's| |\n|g' | sort -u | xargs)"

    if [[ "${operation}" == "update" && "${packages}" != "" ]]; then
        echo "Packages cannot be specified when using the update/upgrade option."
        exit 1
    fi
}
