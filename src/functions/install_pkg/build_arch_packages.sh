build_arch_packages() {
  for i in ${arch_repository_packages}; do
    cd "${i}"
    source PKGBUILD

    echo
    makedeb --convert --pkgname "${i}"

    sudo rm /etc/mpm/repo/debs/"${i}"*.deb &> /dev/null || printf ""
    sudo cp "${i}"_"$(version_gen)"_*.deb /etc/mpm/repo/debs/

    local export_to_database=$(echo "${i}"\\"$(version_gen)"\\"arch_repository")

    if cat /etc/mpm/sources.db | awk -F '\' '{print $1}' | grep "${i}" &> /dev/null; then
      sudo sed -i "s|${i}\\.*|${export_to_database}|" /etc/mpm/sources.db
    else
      echo "${export_to_database}" | sudo tee -a /etc/mpm/sources.db &> /dev/null
    fi

    cd ..
  done
}
