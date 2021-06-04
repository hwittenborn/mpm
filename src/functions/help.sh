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
	echo
	echo "  (search)"
	echo "  -L, --list-pkg - list each package as it's rendered"
	echo
	echo "  (install)"
	echo "  -N, --skip-pkgbuild-check - Skip PKGBUILD checks for AUR packages"
    echo "  -D, --dryrun - build packages, but don't install or register in database"
	echo
	echo "  (clone)"
	echo "  -O, --output-folder - specify a folder to clone files to"
	echo
	echo "Report bugs at https://github.com/hwittenborn/mpm"
	exit 0
}
