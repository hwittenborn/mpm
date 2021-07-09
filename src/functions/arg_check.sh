arg_check() {
	eval set -- ${@}

    case ${1} in
        ""|-h|--help)      show_help; exit 0 ;;
        search)                export operation="search" ;;
        install)               export operation="install"; export operation_string="installed" ;;
        update|upgrade)        export operation="update"; export operation_string="upgraded" ;;
		clone)                 export operation="clone" ;;
        *)                     echo "Unknown command '${1}'. See the list of available commands with 'mpm --help'." ;;
    esac
    shift 1 || true

    while [[ "${1}" != "" ]]; do
        case ${1} in
			-d|--directory)    export clone_directory="${2}"; shift 1 ;;
            -h|--help)         show_help ;;
			-p|--parents)      export mkdir_parents_argument='-p' ;;
            --verbose)         set -x ;;
            -*)                echo "Unknown option '${1}'. See the list of available options with 'mpm --help'." ;;
            *)                 packages_temp+="${1} " ;;
        esac

        shift 1 || true
    done

    # Post-argument checks
    export packages="$(echo "${packages_temp}" | sed 's| |\n|g' | sort -u | xargs)"

    if [[ "${operation}" == "update" && "${packages}" != "" ]]; then
        echo "Packages cannot be specified when using the update/upgrade option."
        exit 1
    fi

	if [[ "${operation}" != "clone" && "${clone_directory}" != "" ]]; then
		echo "'-d' option can only be used with the 'clone' command."
		exit 1
	fi
}
