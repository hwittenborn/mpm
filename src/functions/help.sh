help() {
	echo "mpm - makedeb package manager"
	echo "Usage: mpm [command] [options]"
	echo
	echo "Commands"
	echo "  search - search for a package"
	echo "  clone - clone packages"
	echo "  install - install packages"
	echo "  update - update installed packages"
	echo
	echo "Options:"
	echo "  --help - bring up this help menu"
	echo "  -L, --list-pkg - list each package as it's rendered; for use with 'search'"
	echo "  -O, --output-folder - specify a folder to clone files to; for use with 'clone'"
	echo
	echo "Report bugs at https://github.com/hwittenborn/mpm"
	exit 0
}
