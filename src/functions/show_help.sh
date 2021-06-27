show_help() {
    printf "mpm (${mpm_version}) - makedeb package manager\n\n"

    printf "Usage: mpm [command] [packages/options]\n\n"

    printf "mpm is a reference package manager for the DUR. It allows\n"
    printf "for installing, updating, searching for, and cloning of packages.\n\n"

    printf "Commands:\n"
    printf "  install - install packages\n"
    printf "  update/upgrade - update packages installed through mpm\n"
    printf "  search - search for a package\n"
    printf "  clone - clone a package\n\n"

    printf "Options:\n"
    printf "  -h, --help - bring up this help menu"
}
