#!/usr/bin/env bash
set -Ee
unset packages operation number curl_output \
      dependencies make_dependencies check_dependencies \
      package_list relationship_type

# Variables that we need to function
export dur_url="dur.hunterwittenborn.com"

export system_architecture="$(dpkg --print-architecture)"
export os_codename="$(lsb_release -cs)"

while true; do
    random_string="${RANDOM}${RANDOM}${RANDOM}${RANDOM}${RANDOM}"
    if ! find "/etc/apt/sources.list.d/${random_string}.list" &> /dev/null && \
        ! find "/var/tmp/packages-${random_string}.db" &> /dev/null; then
            break
    fi

    unset random_string
done


# Source functions for testing                        # REMOVE AT PACKAGING
for i in $(find functions); do                        # REMOVE AT PACKAGING
    if ! [[ -d "${i}" ]]; then                        # REMOVE AT PACKAGING
        printf "Sourcing functions from ${i}...\n"    # REMOVE AT PACKAGING
        source <(cat "${i}")                          # REMOVE AT PACKAGING
    fi                                                # REMOVE AT PACKAGING
done                                                  # REMOVE AT PACKAGING
printf '\n'                                           # REMOVE AT PACKAGING
                                                      # REMOVE AT PACKAGING
# Preliminary checks
trap_codes
arg_check ${@}
colorsheet

# Begin script
case ${operation} in
    install)    get_root; install_package ;;
    update)     get_root; update_package ;;
    search)     search_package ;;
esac
