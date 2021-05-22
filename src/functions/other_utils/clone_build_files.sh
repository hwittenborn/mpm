clone_build_files() {
  if [[ ${aur_packages} != "" ]]; then
    for i in ${aur_packages}; do
      echo "Cloning ${i} from the AUR..."
      git clone "${aur_url}${i}.git" &> /dev/null
    done
  fi

  if [[ ${arch_repository_packages} != "" ]]; then
    asp update &> /dev/null
    for i in ${arch_repository_packages} ${arch_dependency_list}; do
      # Clone PKGBUILD with asp
      echo "Cloning ${i} from Arch Linux repositories..."
      local asp_output=$(asp checkout "${i}" &> /dev/stdout | grep "${i} is part of package" | sed "s|==> ${i} is part of package ||")

      if [[ "${asp_output}" != "" ]]; then
        mv "${asp_output}"/trunk/PKGBUILD "${asp_output}"/
        rm "${asp_output}"/{repos,trunk} -rf
        mv "${asp_output}" "${i}"
      else
        mv "${i}"/trunk/PKGBUILD "${i}"/
        rm "${i}"/{repos,trunk} -rf
      fi

      # Clone package from Arch Linux archive
      echo "Cloning binary for ${i}..."
      local arch_repository_package_info=$(curl -s ${arch_repository_search_url}${i})
      local arch_repository_package_repo=$(echo ${arch_repository_package_info} | jq -r .results[].repo)
      local arch_repository_package_epoch=$(echo ${arch_repository_package_info} | jq -r .results[].epoch)
      local arch_repository_package_pkgver=$(echo ${arch_repository_package_info} | jq -r .results[].pkgver)
      local arch_repository_package_pkgrel=$(echo ${arch_repository_package_info} | jq -r .results[].pkgrel)
      local arch_repository_package_arch=$(echo ${arch_repository_package_info} | jq -r .results[].arch)


      # Check epoch for curl command below
      if [[ ${arch_repository_package_epoch} != "0" ]]; then
        arch_repository_package_epoch_status="${arch_repository_package_epoch}:"
      fi

      local package_archive_name="${i}"-"${arch_repository_package_epoch_status}""${arch_repository_package_pkgver}"-"${arch_repository_package_pkgrel}-${arch_repository_package_arch}"
      local pkgname_first_letter=$(echo ${i} | head -c 1)
      curl -s "${arch_archive_url}"packages/"${pkgname_first_letter}"/"${i}"/${package_archive_name}.pkg.tar.zst \
           -o "${i}"/"${package_archive_name}".pkg.tar.zst
    done
  fi
}
