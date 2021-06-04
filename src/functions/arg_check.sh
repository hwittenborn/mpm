arg_check() {
	while true; do
		case "${1}" in
			--help | "")                   help ;;
            -D | --dryrun)                 export arg_dryrun="true" ;;
			-L | --list-pkg)               LIST_PER_PACKAGE="true" ;;
			-O | --output-folder)          OUTPUT_FOLDER="${2}"; shift 1;;
			-N | --skip-pkgbuild-check)    SKIP_PKGBUILD_CHECK="TRUE" ;;

            --skippgpcheck)                export makedeb_options+= " ${1}" ;;
			-*)                            echo "Unknown option '${1}'"; exit 1 ;;

			search)                        OP="search"; shift 1; break ;;
			clone)                         OP="clone"; shift 1; break ;;
			install)                       OP="install"; shift 1; break ;;
			update | upgrade)              OP="upgrade"; PKG="TEMP"; shift 1; break ;;
			*)                             echo "Invalid option '${1}'..."; exit 1 ;;
		esac
		shift 1
	done

	while true; do
		case "${1}" in
			--help)                        help ;;
            -D | --dryrun)                 export arg_dryrun="true" ;;
			-L | --list-pkg)               LIST_PER_PACKAGE="TRUE" ;;
			-O | --output-folder)          OUTPUT_FOLDER="${2}"; shift 1;;
			-N | --skip-pkgbuild-check)    SKIP_PKGBUILD_CHECK="TRUE" ;;

            --skippgpcheck)                export makedeb_options+= " ${1}" ;;
			-*)                            echo "Invalid option '${1}'"; exit 1 ;;
			"")                            break ;;
			*)                             PKG+=" ${1}" ;;
		esac
		shift 1
	done

	if [[ "${PKG}" == "" ]]; then
		echo "Package field is empty"
		exit 1
	fi
}
