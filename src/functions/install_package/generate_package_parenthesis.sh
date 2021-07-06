# This is used to convert Arch-style package relationships ('foo>1') to
# APT-style ones ('foo (>> 1)')
generate_package_parenthesis() {

    # Duplicate relationship symbol twice for '<' and '>' per Debian's policy
    for i in '<' '>'; do
        if [[ "$(echo "${1}" | grep "${i}[[:digit:]]")" != "" ]]; then
            symbol_type="${i}${i}"
            break
        fi
    done

    # Everything else just stays the same
    if [[ "${symbol_type}" == "" ]]; then
        symbol_type="$(echo "${1}" | grep -Eo '<=|>=|=[[:digit:]]')" || true
    fi


    if [[ "${symbol_type}" != "" ]]; then
        package_name="$(echo "${1}" | awk -F "${symbol_type}" '{print $1}')"
        package_version="$(echo "${1}" | awk -F "${symbol_type}" '{print $2}')"
    else
        package_name="${1}"
    fi

    # Single quotes will get removed when checking packages with APT, as we'll use 'eval'
    if [[ "${symbol_type}" != "" ]]; then
        apt_packages+=("'${package_name} (${symbol_type} ${package_version})'")
    else
        apt_packages+=("'${package_name}'")
    fi

    unset symbol_type  package_name  package_version
}
