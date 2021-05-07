clone_build_files() {
  if [[ ${aur_packages} != "" ]]; then
    for i in ${aur_packages}; do
      echo "Cloning ${i} from the AUR..."
      git clone "${aur_url}${i}.git"
    done
  fi
  
  if [[ ${arch_repository_packages} != "" ]]; then
    for i in ${arch_repository_packages}; do
      # Clone PKGBUILD with asp
      echo "Cloning PKGBUILD for ${i}..."
      asp checkout "${i}" &> /dev/null
      mv "${i}"/trunk/PKGBUILD "${i}"/
      rm "${i}"/{repos,trunk} -rf

      # Clone package from Arch Linux archive
      echo "Cloning binary for ${i}..."
      local arch_repository_package_info=$(curl -s ${arch_repository_search_url}${i})
      local arch_repository_package_repo=$(echo ${arch_repository_package_info} | jq -r .results[].repo)
      local arch_repository_package_epoch=$(echo ${arch_repository_package_info} | jq -r .results[].epoch)
      local arch_repository_package_pkgver=$(echo ${arch_repository_package_info} | jq -r .results[].pkgver)
      local arch_repository_package_pkgrel=$(echo ${arch_repository_package_info} | jq -r .results[].pkgrel)
      local arch_repository_package_arch=$(echo ${arch_repository_package_info} | jq -r .results[].arch)


      # Check epoch for curl command below
      if [[ ${arch_repository_package_epoch} -gt "1" ]]; then
        arch_repository_package_epoch_status="${arch_repository_package_epoch}:"
      fi

      local package_archive_name="${i}"-"${arch_repository_package_epoch_status}""${arch_repository_package_pkgver}"-"${arch_repository_package_pkgrel}-${arch_repository_package_arch}"
      local pkgname_first_letter=$(echo ${i} | head -c 1)
      curl -s "${arch_archive_url}"packages/"${pkgname_first_letter}"/"${i}"/${package_archive_name}.pkg.tar.zst \
           -o "${i}"/"${package_archive_name}".pkg.tar.zst
    done
  fi
}
