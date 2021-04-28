install_packages() {

  echo "Installing '${PKG}'..."
  cd /etc/mpm/repo
  dpkg-scanpackages debs | sudo tee Packages &> /dev/null
  sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/mpm.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0" &> /dev/null
  sudo apt install ${PKG} -y

}
