check_build_sources() {
  # Pull package list from AUR
  for i in ${PKG}; do
    aur_search_args+="&arg[]=${i}"
  done
  aur_search_url="${aur_url}rpc.php/rpc/?v=5&type=info${aur_search_args}"
  aur_search_results=$(curl -s -H "User-Agent: mpm/${mpm_version}" "${aur_search_url}")


  for i in ${PKG}; do
    # Get results from AUR and Arch Repositories
    arch_repository_search_results=$(curl -s -H "User-Agent: mpm/${mpm_version}" "${arch_repository_search_url}${i}")

    if [[ $(echo "${aur_search_results}" | jq -r '.results[].Name' | grep -x "${i}") != "" ]]; then
      # Figure out position of AUR package in results
      # 1. Set pkgver for awk in while loop
      # 2. Pipe results to jq to get the names of all packages
      # 3. Use awk to print the line specified under $awk_pkgver
      # 4. Check if the value is equal to the package specified in the for loop above
      local awk_pkgver="1"
      while [[ $(echo "${aur_search_results}" | jq -r .results[].Name | awk NR=="${awk_pkgver}") != "${i}" ]]; do
        export awk_pkgver=$(( "${awk_pkgver}" + 1 ))
      done

      # Get AUR package version
      local aur_search_results_pkgver=$(echo "${aur_search_results}" | jq -r .results[].Version | awk NR=="${awk_pkgver}")
      # Print local version (if installed)
      if [[  "${aur_search_results_pkgver}" !=  $(apt list "${i}" 2> /dev/null | grep -E "$(dpkg --print-architecture)|all" | grep '\[installed,' | awk -F ' ' '{print $2}') ]]; then
        aur_packages+=" ${i}"
      else
        export apt_uptodate_message+="${i} is already up to date (${aur_search_results_pkgver})\n"
        # Save to separate variable for clone_pkg(), as it needs to clone even if up to date
        export aur_clone_packages=" ${i}"
      fi

    elif [[ $(echo ${arch_repository_search_results} | jq .results[].pkgname) != "null" ]]; then
      export arch_repository_search_results_pkgver=$(echo "${arch_repository_search_results}" | jq -r .results[].pkgver)
      if [[ "${arch_repository_search_results_pkgver}"  !=  $(apt list "${i}" 2> /dev/null | grep -E "$(dpkg --print-architecture)|all" | grep '\[installed,' |awk -F ' ' '{print $2}') ]]; then
        export arch_repository_packages+=" ${i}"
      else
        export apt_uptodate_message+="${i} is already up to date (${arch_repository_search_results_pkgver})\n"
        # Save to separate variable for clone_pkg(), as it needs to clone even if up to date
        export arch_clone_packages=" ${i}"
      fi
    else
      FIND_NULL+=" ${i}"
    fi

    FIND_NULL=$(echo "${FIND_NULL}" | sed 's/ //')
    if [[ ${FIND_NULL} != "" ]]; then
      echo "Couldn't find the following packages: $(echo ${FIND_NULL} | xargs | sed 's| |, |g')"
      exit 1
    fi
  done

  aur_packages=$(echo ${aur_packages} | xargs)
  arch_repository_packages=$(echo ${arch_repository_packages} | xargs)
}
