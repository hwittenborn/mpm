install_packages() {
  echo "deb [trusted=yes] file:///etc/mpm/repo /" | sudo tee /etc/apt/sources.list.d/mpm.list &> /dev/null

  cd /etc/mpm/repo
  dpkg-scanpackages debs | sudo tee Packages &> /dev/null
  sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/mpm.list" \
                      -o Dir::Etc::sourceparts="-" \
                      -o APT::Get::List-Cleanup="0" &> /dev/null

  sudo apt install -y ${aur_packages} ${arch_repository_packages} -y

  sudo rm /etc/apt/sources.list.d/mpm.list
  sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/mpm.list" \
                      -o Dir::Etc::sourceparts="-" \
                      -o APT::Get::List-Cleanup="0" &> /dev/null
}
