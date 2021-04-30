arg_check() {
	while true; do
		case "${1}" in
			--help | "")        help ;;
			-L | --list-pkg)    LIST_PER_PACKAGE="TRUE" ;;
			-U | -u | --user)        BUILD_USER="${2}"; shift 1 ;;
			-*)                 echo "Unknown option '${1}'"; exit 1 ;;

			search)        OP="search"; shift 1; break ;;
			install)       OP="install"; shift 1; break ;;
			update)        OP="update"; PKG="TEMP"; shift 1; break ;;
			*)             echo "Invalid option '${1}'..."; exit 1 ;;
		esac
		shift 1
	done

	while true; do
		case "${1}" in
			--help)             help ;;
			-L | --list-pkg)    LIST_PER_PACKAGE="TRUE" ;;
			-U | -u | --user)        BUILD_USER="${2}"; shift 1 ;;
			-*)                 echo "Invalid option '${1}'"; exit 1 ;;
			"")                 break ;;
			*)                  PKG+=" ${1}" ;;
		esac
		shift 1
	done

	if [[ "${PKG}" == "" ]]; then
		echo "Package field is empty"
		exit 1
	fi
}
