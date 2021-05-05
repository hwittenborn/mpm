clone_files() {

  echo "Cloning build files..."
  for package in ${PKG}; do
    git clone "${aur_url}${package}.git" &> /dev/null
  done

  for package in ${PKG}; do
    echo "Look over files for '${package}'?"
    printf "Enter yes(y) or no(n): "
    read check_files

    while [[ ${check_files} != "yes" ]] && [[ ${check_files} != "y" ]] && [[ ${check_files} != "no" ]] && [[ ${check_files} != "n" ]]; do
      echo "Invalid option provided"
      echo " Enter yes(y) or no(n)"
      read -p check_files
    done

    while [[ ${check_files} == "yes" ]] || [[ ${check_files} == "y" ]]; do
      nano "${package}"/PKGBUILD
      source "${package}"/PKGBUILD
      for notlink in ${source[@]}; do
        echo "${notlink}" | grep "http" &> /dev/null
        if [[ ${?} != "0" ]]; then
          nano "${package}"/"${notlink}"
        fi
      done
      sleep 1

      echo "Look over files for '${package}'?"
      echo "Enter yes(y) or no(n)"
      read check_files

      while [[ ${check_files} != "yes" ]] && [[ ${check_files} != "y" ]] && [[ ${check_files} != "no" ]] && [[ ${check_files} != "n" ]]; do
        echo "Invalid option provided"
        echo " Enter yes(y) or no(n)"
        read check_files
      done
    done
  done

}
