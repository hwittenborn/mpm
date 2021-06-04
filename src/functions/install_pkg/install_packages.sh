install_packages() {
  cd /etc/mpm/repo
  dpkg-scanpackages debs | sudo tee Packages &> /dev/null
  sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/mpm.list" \
                      -o Dir::Etc::sourceparts="-" \
                      -o APT::Get::List-Cleanup="0" &> /dev/null

  sudo apt "${OP}" $([[ "${OP}" != "upgrade" ]] && echo ${aur_packages} ${arch_repository_packages}) -y

  sudo rm /etc/apt/sources.list.d/mpm.list
  sudo apt-get update -o Dir::Etc::sourcelist="sources.list.d/mpm.list" \
                      -o Dir::Etc::sourceparts="-" \
                      -o APT::Get::List-Cleanup="0" &> /dev/null
}
