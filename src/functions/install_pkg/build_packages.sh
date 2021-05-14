aur_build_packages() {
  for i in ${aur_packages}; do
    cd "${i}"
    makedeb --convert
    CONTROL_NAME="$(cat pkg/DEBIAN/control | grep "Package:" | awk '{print $2}')_$(cat pkg/DEBIAN/control | grep "Version:" | awk '{print $2}')_$(cat pkg/DEBIAN/control | grep "Architecture:" | awk '{print $2}')"

    { sudo rm /etc/mpm/repo/debs/"$(cat pkg/DEBIAN/control | grep "Package:" | awk '{print $2}')"* &> /dev/null; } || printf ""
    sudo cp ${CONTROL_NAME}.deb /etc/mpm/repo/debs

    export_package_db=$(echo ${i}\\$(cat pkg/DEBIAN/control | grep "Version:" | awk '{print $2}')\\aur)
    if [[ $(cat /etc/mpm/sources.db | awk -F '\' '{print $1}' | grep "${i}") ]]; then
      export_package_db_backslashes=$(echo ${export_package_db} | sed 's|\\|\\\\|g')
      sed -i "s|${i}\\\\.*|${export_package_db_backslashes}|" /etc/mpm/sources.db
    else
      echo "${export_package_db}" | sudo tee -a /etc/mpm/sources.db &> /dev/null
    fi
    cd ..
  done
}

arch_repository_build_packages() {
  for i in ${arch_repository_packages}; do
    cd "${i}"
    makedeb --prebuilt --convert
    CONTROL_NAME="$(cat pkg/DEBIAN/control | grep "Package:" | awk '{print $2}')_$(cat pkg/DEBIAN/control | grep "Version:" | awk '{print $2}')_$(cat pkg/DEBIAN/control | grep "Architecture:" | awk '{print $2}')"
    { sudo rm /etc/mpm/repo/debs/"$(cat pkg/DEBIAN/control | grep "Package:" | awk '{print $2}')"* &> /dev/null; } || printf ""
    sudo cp ${CONTROL_NAME}.deb /etc/mpm/repo/debs

    export_package_db=$(echo ${i}\\$(cat pkg/DEBIAN/control | grep "Version:" | awk '{print $2}')\\arch_repository)
    if [[ $(cat /etc/mpm/sources.db | awk -F '\' '{print $1}' | grep "${i}") ]]; then
      export_package_db_backslashes=$(echo ${export_package_db} | sed 's|\\|\\\\|g')
      sed -i "s|${i}\\\\.*|${export_package_db_backslashes}|" /etc/mpm/sources.db
    else
      echo "${export_package_db}" | sudo tee -a /etc/mpm/sources.db &> /dev/null
    fi

    cd ..
  done
}
