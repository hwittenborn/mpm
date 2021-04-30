build_packages() {

  echo "Building packages. This may take a bit..."
  for package in ${PKG}; do
    cd "${package}"
    makedeb
    CONTROL_NAME="$(cat pkg/DEBIAN/control | grep "Package:" | awk '{print $2}')_$(cat pkg/DEBIAN/control | grep "Version:" | awk '{print $2}')_$(cat pkg/DEBIAN/control | grep "Architecture:" | awk '{print $2}')"

    sudo rm /etc/mpm/repo/debs/"$(cat pkg/DEBIAN/control | grep "Package:" | awk '{print $2}')"*
    sudo cp ${CONTROL_NAME}.deb /etc/mpm/repo/debs
    cd ..
  done

}
