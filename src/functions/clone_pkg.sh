clone_pkg() {
  # Make sure folder is created and writable
  if [[ "${OUTPUT_FOLDER}" != "" ]]; then
    if ! [[ -d "${OUTPUT_FOLDER}" ]]; then
      echo "Creating folder"
      mkdir "${OUTPUT_FOLDER}"

    elif ! [[ -w "${OUTPUT_FOLDER}" ]]; then
      echo "Folder isn't writable"
      exit 1
    fi

    cd "${OUTPUT_FOLDER}"
  fi

  check_packages

  for i in ${aur_packages}; do
    echo "Cloning ${i}..."
    git clone "${aur_url}${i}.git"
  done

  for i in ${arch_repository_packages}; do
    echo "Cloning ${i}"...
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
}
