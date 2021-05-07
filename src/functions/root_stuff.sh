root_check() {
  if [[ "$(whoami)" == "root" ]]; then
    echo "Running mpm directly as root is not allowed as it can cause irreversable damage to your system."
    exit 1
  fi
}

get_root() {
  sudo printf "" || { echo "Couldn't obtain root privileges"; exit 1; }
}
