aur_clone_files() {
  if [[ ${aur_packages} != "" ]]; then
    echo "Cloning AUR build files..."
    for i in ${aur_packages}; do
      git clone "${aur_url}${i}.git" &> /dev/null
    done

    for i in ${aur_packages}; do
      echo "Look over files for '${i}'?"
      printf "Enter yes(y) or no(n): "
      read check_files

      while [[ ${check_files} != "yes" ]] && [[ ${check_files} != "y" ]] && [[ ${check_files} != "no" ]] && [[ ${check_files} != "n" ]]; do
        echo "Invalid option provided"
        echo " Enter yes(y) or no(n)"
        read -p check_files
      done

      while [[ ${check_files} == "yes" ]] || [[ ${check_files} == "y" ]]; do
        nano "${i}"/PKGBUILD
        source "${i}"/PKGBUILD
        for notlink in ${source[@]}; do
          echo "${notlink}" | grep "http" &> /dev/null
          if [[ ${?} != "0" ]]; then
            nano "${i}"/"${notlink}"
          fi
        done
        sleep 1

        echo "Look over files for '${i}'?"
        echo "Enter yes(y) or no(n)"
        read check_files

        while [[ ${check_files} != "yes" ]] && [[ ${check_files} != "y" ]] && [[ ${check_files} != "no" ]] && [[ ${check_files} != "n" ]]; do
          echo "Invalid option provided"
          echo " Enter yes(y) or no(n)"
          read check_files
        done
      done
    done
  fi
}

arch_repository_clone_files() {
  if [[ ${arch_repository_packages} != "" ]]; then
    echo "Cloning Arch Linux packages"
    for i in ${arch_repository_packages}; do
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
      mkdir ${i}
      curl -s "${arch_archive_url}"packages/"${pkgname_first_letter}"/"${i}"/${package_archive_name}.pkg.tar.zst \
           -o "${i}"/"${package_archive_name}".pkg.tar.zst

      if [[ "${arch_repository_package_repo}" == "community" ]]; then
        curl -s "${arch_github_url}"/svntogit-community/blob/master/"${i}"/trunk/PKGBUILD -o "${i}"/PKGBUILD
      elif [[ "${arch_repository_package_repo}" == "extra" ]]; then
        curl -sL "${arch_github_url}"/svntogit-packages/raw/master/"${i}"/trunk/PKGBUILD -o "${i}"/PKGBUILD
      fi
    done
  fi
}
