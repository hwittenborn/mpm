help() {
	echo "mpm - makedeb package manager"
	echo "Usage: mpm [command] [options]"
	echo
	echo "Commands"
	echo "  search - search for a package"
	echo "  install - install packages from the AUR"
	echo "  update - update installed AUR packages"
	echo
	echo "Options:"
	echo "  --help - bring up this help menu"
	echo "  -L, --list-pkg - list each package as it's rendered; for use with 'search'"
	echo "  -U, -u, --user - specify a user to build as when running as root"
	echo
	echo "Report bugs at https://github.com/hwittenborn/mpm"
	exit 0
}
