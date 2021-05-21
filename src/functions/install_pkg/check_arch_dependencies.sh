check_arch_dependencies() {
  for i in ${PKG}; do
    local arch_dependency_results=$(makedeb-db --package ${i} | jq -r .arch_packages | grep -vw "null")

    if ! { echo "${PKG}" | grep "${arch_dependency_results}" &> /dev/null; }; then
      add_arch_dependency_list+=" ${arch_dependency_results}"
    fi
  done

  # Keep looping until cache is equal to packages added on run;
  # used for recursive dependencies.
  while true; do
    local grep_string=$(echo "${add_arch_dependency_cache}" | sed 's/ /|/g')
    for i in ${add_arch_dependency_list}; do
      local arch_dependency_results=$(makedeb-db --package ${i} | jq -r .arch_packages | grep -vw "null")

      if ! { echo "${PKG}" | grep -vE "${grep_string}" &> /dev/null; }; then
        add_arch_dependency_list+=" ${arch_dependency_results}"
      fi

      if [[ $(echo ${add_arch_dependency_cache} | xargs) != $(echo ${add_arch_dependency_list} | xargs) ]]; then
        add_arch_dependency_cache=${add_arch_dependency_list}
      else
        break 2
      fi
    done

done

arch_dependency_list=$(echo "${add_arch_dependency_list}" | xargs)
}
