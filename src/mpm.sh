#!/usr/bin/env bash
set -Ee
unset packages operation number curl_output \
      dependencies make_dependencies check_dependencies \
      package_list relationship_type

# Variables that we need to function
export dur_url="dur.hunterwittenborn.com"

export mpm_version="git"
export system_architecture="$(dpkg --print-architecture)"
export os_codename="$(lsb_release -cs)"

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

# Argument Check
arg_number="$#"
number=1
while [[ "${number}" -le "${arg_number}" ]]; do
    split_args "$(eval echo \${$number})"
    number="$(( "${number}" + 1 ))"
done

arg_check ${argument_list[@]@Q}

# Colorsheet
colorsheet

# Begin script
case ${operation} in
    install)    get_root; install_package ;;
    update)     get_root; update_package ;;
    search)     search_package ;;
	clone)      clone_package ;;
esac
