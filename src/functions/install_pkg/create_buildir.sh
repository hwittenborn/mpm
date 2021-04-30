create_builddir() {
  # Check if makedeb build directory exists for the current user.
  ls /tmp/"${USER}"/makedeb &> /dev/null
  if [[ ${?} == "0" ]]; then
    rm -rf /tmp/"${USER}"/makedeb || { echo "Couldn't delete old build directory"; exit 1; }
  fi

  sudo mkdir -p /tmp/"${USER}"/makedeb &> /dev/null
  sudo chown "${USER}" /tmp/"${USER}"/makedeb
  cd /tmp/"${USER}"/makedeb

}
