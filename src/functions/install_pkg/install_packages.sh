install_packages() {

  echo "Installing packages..."
  sudo echo "deb [trusted=yes] file:///etc/mpm/repo /" > /etc/apt/sources.list.d/mpm.list

  cd /etc/mpm/repo
  dpkg-scanpackages debs | sudo tee Packages &> /dev/null
  sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/mpm.list" \
                      -o Dir::Etc::sourceparts="-" \
                      -o APT::Get::List-Cleanup="0" &> /dev/null

  sudo apt install -y -o Dir::Etc::sourcelist="sources.list.d/mpm.list" \
                      -o Dir::Etc::sourceparts="-" \
                      -o APT::Get::List-Cleanup="0" \
                      ${PKG} -y

  sudo rm /etc/apt/sources.list.d/mpm.list
  sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/mpm.list" \
                      -o Dir::Etc::sourceparts="-" \
                      -o APT::Get::List-Cleanup="0" &> /dev/null
}
