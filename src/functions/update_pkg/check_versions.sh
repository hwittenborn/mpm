check_versions() {
  local sources_db_content=$(cat /etc/mpm/sources.db)
  local number="1"
  for i in $(echo "${sources_db_content}" | awk -F '\' '{print $1}'); do
    if [[ $(echo "${sources_db_content}" | awk -F '\' '{print $3}' | awk NR==${number}) == "aur" ]]; then
      local pkg_local_version=$(echo "${sources_db_content}" | awk -F '\' '{print $2}' | awk NR==${number})
      local pkg_aur_version=$(curl -s "${aur_url}rpc.php/rpc/?v=5&type=info&arg=${i}" | jq .results[].Version)

      local pkg_highest_version=$(echo ${pkg_local_version} ${pkg_aur_version} | sort -V | awk '{print $2}')

      if [[ "${pkg_highest_version}" != "${pkg_local_version}" ]]; then
        to_update+=" ${i}"
      fi

    elif [[ $(echo "${sources_db_content}" | awk -F '\' '{print $3}' | awk NR==${number}) == "arch_repository" ]]; then
      local pkg_local_version=$(echo "${sources_db_content}" | awk -F '\' '{print $2}' | awk NR==${number})
      local pkg_arch_repository_results=$(curl -s "${arch_repository_search_url}${i}")
        local pkg_arch_repository_epoch=$(echo ${pkg_arch_repository_results} | jq .results[].epoch)
        local pkg_arch_repository_epoch=$(echo ${pkg_arch_repository_results} | jq .results[].pkgver)
        local pkg_arch_repository_epoch=$(echo ${pkg_arch_repository_results} | jq .results[].pkgrel)
        if [[ "${epoch}" -gt "1" ]]; then
          pkg_arch_repository_epoch_status="${epoch}:"
        fi
        pkg_arch_repository_version="${pkg_arch_repository_epoch_status}${pkgver}-${pkgrel}"

        local pkg_highest_version=$(echo ${pkg_local_version} ${pkg_arch_repository_version} | sort -V | awk '{print $2}')

        if [[ "${pkg_highest_version}" != "${pkg_local_version}" ]]; then
          to_update+=" ${i}"
        fi
    fi

    number=$(( ${number} + 1 ))
  done
  to_update=$(echo ${to_update} | xargs)
}
