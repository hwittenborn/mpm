aur_check_files() {
  for i in ${aur_packages}; do
    echo "Look over files for '${i}'?"
    printf "Enter yes(y) or no(n): "
    read check_files

    while [[ ${check_files} != "yes" ]] && [[ ${check_files} != "y" ]] && [[ ${check_files} != "no" ]] && [[ ${check_files} != "n" ]]; do
      echo "Invalid option provided"
      printf " Enter yes(y) or no(n): "
      read -p check_files
    done

    while [[ ${check_files} == "yes" ]] || [[ ${check_files} == "y" ]]; do
      nano "${i}"/PKGBUILD
      source "${i}"/PKGBUILD

      num="0"
      while [[ $(eval echo \${source[${num}]}) != "" ]]; do
        if eval echo \${source[${num}]} | grep "http" &> /dev/null; then
          num=$(( ${num} + 1 ))
          continue
        fi

        nano "${i}"/$(eval echo \${source[${num}]} | sed 's|[^ ]*/||')
        num=$(( ${num} + 1 ))
      done
      sleep 1

      echo "Look over files for '${i}'?"
      printf "Enter yes(y) or no(n): "
      read check_files

      while [[ ${check_files} != "yes" ]] && [[ ${check_files} != "y" ]] && [[ ${check_files} != "no" ]] && [[ ${check_files} != "n" ]]; do
        echo "Invalid option provided"
        printf "Enter yes(y) or no(n): "
        read check_files
      done
    done
  done
}
