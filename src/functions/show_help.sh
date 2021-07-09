show_help() {
    echo "mpm (${mpm_version}) - makedeb package manager"
    echo
    echo "Usage: mpm [command] [packages/options]"
    echo
    echo "mpm is a reference package manager for the MPR. It allows"
    echo "for installing, updating, searching for, and cloning of packages."
    echo
    echo "Commands:"
    echo "  install            Install packages"
    echo "  update/upgrade     Check for and install updates"
    echo "  search             Search for a package"
	echo "  clone              Clone packages"
    echo
    echo "Options:"
	echo "  -d, --directory    Specifies an (empty) output directory when using the 'clone' command"
	echo "  -p, --parents      Create parent directories if they don't exist when using the '-d' option"
    echo "  -h, --help         Bring up this help menu and exit"
    echo "  --verbose          Print (very) detailed logging"
}
