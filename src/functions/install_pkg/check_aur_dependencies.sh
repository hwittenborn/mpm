check_aur_dependencies() {
  for i in depends makedepends; do
    for j in ${PKG}; do
      # Unset important variables on each loop because I'm paranoid I messed up somewhere
      unset aur_dependency_results  aur_dependency_empty  add_aur_dependency_list

      local aur_${i}_results=$(makedeb-db --package ${j} | jq -r .aur_packages | grep -vw "null")
      # Set variable without subvariables($i) so we're not calling a ton of subfunctions with eval
      local aur_dependency_results=$(eval echo \${aur_${i}_results})

      if [[ "${aur_dependency_results}" == "" ]]; then
        export aur_${i}_empty="true"
        # Set variable without subvariables($i) so we're not calling a ton of subfunctions with eval
        export aur_dependency_empty=$(eval echo \${aur_${i}_empty})
      fi

      if ! { echo "${PKG}" | grep "${aur_dependency_results}" &> /dev/null; }; then
        export add_aur_dependency_list+=" ${aur_dependency_results}"
      fi
    done

    # Keep looping until cache list is equal to packages added on run;
    # used for recursive dependencies.
    [[ "${aur_dependency_empty}" != "true" ]] && while true; do
      local grep_string=$(echo "${add_aur_dependency_list}" | sed 's/ /|/g')
      for j in ${add_aur_dependency_list}; do
        local aur_${i}_results=$(makedeb-db --package ${j} | jq -r .aur_packages | grep -vw "null")
        # Set variable without subvariables($i) so we're not calling a ton of subfunctions with eval
        local aur_dependency_results=$(eval echo \${aur_${i}_results})

        if ! { echo "${PKG}" | grep -vE "${grep_string}" &> /dev/null; }; then
          add_aur_dependency_list+=" ${aur_dependency_results}"
        fi

        if [[ $(echo ${add_aur_dependency_cache} | xargs) != $(echo ${add_aur_dependency_list} | xargs) ]]; then
          add_aur_dependency_list=${add_aur_dependency_list}
        else
          break 2
        fi
      done
    done

    export aur_${i}_list=$(echo "${add_aur_dependency_list}" | xargs)
  done
}
