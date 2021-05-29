create_builddir() {
  # Check if makedeb build directory exists for the current user.
  if ls /tmp/"${USER}"/makedeb &> /dev/null; then
    rm -rf /tmp/"${USER}"/makedeb || { echo "Couldn't delete old build directory"; exit 1; }
  fi

  mkdir -p /tmp/"${USER}"/makedeb &> /dev/null
  chown "${USER}" /tmp/"${USER}"/makedeb
  cd /tmp/"${USER}"/makedeb

}
