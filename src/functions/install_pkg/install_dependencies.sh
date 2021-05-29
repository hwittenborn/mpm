if [[ "${aur_depends_list}" != "" ]]  ||  [[ "${arch_depends_list}" != "" ]]  ||  [[ "${arch_makedepends_list}" != "" ]]; then
  local apt_output=$(apt list ${aur_depends_list} ${arch_depends_list} ${arch_makedepends_list} 2> /dev/null | grep -E "$(dpkg --print-architecture)|all")

  for i in ${aur_depends_list}; do
    if echo ${apt_output} | grep "${i}/" | grep -v '[installed,' &> /dev/null; then
      export new_aur_d
