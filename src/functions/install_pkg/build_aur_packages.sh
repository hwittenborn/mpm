build_aur_packages() {
  for i in ${aur_packages}; do
      build_package "${i}" "aur"
  done
}
