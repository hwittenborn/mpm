aur_build_packages() {
  for i in ${aur_packages}; do
    cd "${i}"
    makedeb
    CONTROL_NAME="$(cat pkg/DEBIAN/control | grep "Package:" | awk '{print $2}')_$(cat pkg/DEBIAN/control | grep "Version:" | awk '{print $2}')_$(cat pkg/DEBIAN/control | grep "Architecture:" | awk '{print $2}')"

    sudo rm /etc/mpm/repo/debs/"$(cat pkg/DEBIAN/control | grep "Package:" | awk '{print $2}')"* &> /dev/null
    sudo cp ${CONTROL_NAME}.deb /etc/mpm/repo/debs
    cd ..
  done
}

arch_repository_build_packages() {
  for i in ${arch_repository_packages}; do
    cd "${i}"
    makedeb --prebuilt
    CONTROL_NAME="$(cat pkg/DEBIAN/control | grep "Package:" | awk '{print $2}')_$(cat pkg/DEBIAN/control | grep "Version:" | awk '{print $2}')_$(cat pkg/DEBIAN/control | grep "Architecture:" | awk '{print $2}')"
    { sudo rm /etc/mpm/repo/debs/"$(cat pkg/DEBIAN/control | grep "Package:" | awk '{print $2}')"* &> /dev/null; } || printf ""
    sudo cp ${CONTROL_NAME}.deb /etc/mpm/repo/debs
    cd ..
  done
}
