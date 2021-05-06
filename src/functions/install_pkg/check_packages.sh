check_packages() {

  for i in ${PKG}; do
    aur_search_url="${aur_url}rpc.php/rpc/?v=5&type=info&arg=${i}"

    aur_search_results=$(curl -s "${aur_search_url}")
    arch_repository_search_results=$(curl -s "${arch_repository_search_url}${i}")

    if [[ $(echo ${aur_search_results} | jq -r '.resultcount') != "0" ]]; then
      aur_packages+=" ${i}"
    elif [[ $(echo ${arch_repository_search_results} | \
              grep pkgname | \
              sed 's|"||g' | \
              sed 's|pkgname: ||g' | \
              sed 's|,||g' | \
              sed 's| ||g' | \
              wc -w) != "0" ]]; then
      arch_repository_packages+=" ${i}"
    else
      FIND_NULL+="${i}"
    fi

    FIND_NULL=$(echo "${FIND_NULL}" | sed 's/ //')
    if [[ ${FIND_NULL} != "" ]]; then
      echo "Couldn't find package(s) ${FIND_NULL}"
      exit 1
    fi
  done

  aur_packages=$(echo ${aur_packages} | xargs)
  arch_repository_packages=$(echo ${arch_repository_packages} | xargs)
}
