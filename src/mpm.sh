#!/usr/bin/env bash
unset packages operation number curl_output \
      dependencies make_dependencies check_dependencies \
      package_list relationship_type

# Variables that we need to function
export dur_url="dur.hunterwittenborn.com"

export system_architecture="$(dpkg --print-architecture)"
export os_codename="$(lsb_release -cs)"

# Source functions for testing                                                      # REMOVE AT PACKAGING
for i in $(find functions); do                                                      # REMOVE AT PACKAGING
    if ! [[ -d "${i}" ]]; then                                                      # REMOVE AT PACKAGING
        printf "Sourcing functions from ${i}...\n"                                  # REMOVE AT PACKAGING
        source <(cat "${i}")                                                        # REMOVE AT PACKAGING
    fi                                                                              # REMOVE AT PACKAGING
done                                                                                # REMOVE AT PACKAGING
printf '\n'                                                                         # REMOVE AT PACKAGING
                                                                                    # REMOVE AT PACKAGING
# Preliminary checks
arg_check ${@}
colorsheet

# Begin script
case ${operation} in
    install)    install_package ;;
    update)     update_package ;;
    search)     search_package ;;
esac
