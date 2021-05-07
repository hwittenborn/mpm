aur_check_files() {
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
}
