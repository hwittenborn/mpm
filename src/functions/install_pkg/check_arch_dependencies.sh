check_arch_dependencies() {
  for i in depends makedepends; do
    for j in ${PKG}; do
      # Unset important variables on each loop because I'm paranoid I messed up somewhere
      unset arch_dependency_results  arch_dependency_empty  add_arch_dependency_list

      local arch_${i}_results=$(makedeb-db --package ${j} | jq -r .arch_packages | grep -vw "null")
      # Set variable without subvariables($i) so we're not calling a ton of subfunctions with eval
      local arch_dependency_results=$(eval echo \${arch_${i}_results})

      if [[ "${arch_dependency_results}" == "" ]]; then
        export arch_${i}_empty="true"
        # Set variable without subvariables($i) so we're not calling a ton of subfunctions with eval
        export arch_dependency_empty=$(eval echo \${arch_${i}_empty})
      fi

      if ! { echo "${PKG}" | grep "${arch_dependency_results}" &> /dev/null; }; then
        export add_arch_dependency_list+=" ${arch_dependency_results}"
      fi
    done

    # Keep looping until cache list is equal to packages added on run;
    # used for recursive dependencies.
    [[ "${arch_dependency_empty}" != "true" ]] && while true; do
      local grep_string=$(echo "${add_arch_dependency_list}" | sed 's/ /|/g')
      for j in ${add_arch_dependency_list}; do
        local arch_${i}_results=$(makedeb-db --package ${j} | jq -r .arch_packages | grep -vw "null")
        # Set variable without subvariables($i) so we're not calling a ton of subfunctions with eval
        local arch_dependency_results=$(eval echo \${arch_${i}_results})

        if ! { echo "${PKG}" | grep -vE "${grep_string}" &> /dev/null; }; then
          add_arch_dependency_list+=" ${arch_dependency_results}"
        fi

        if [[ $(echo ${add_arch_dependency_cache} | xargs) != $(echo ${add_arch_dependency_list} | xargs) ]]; then
          add_arch_dependency_list=${add_arch_dependency_list}
        else
          break 2
        fi
      done
    done

    export arch_${i}_list=$(echo "${add_arch_dependency_list}" | xargs)
  done
}
