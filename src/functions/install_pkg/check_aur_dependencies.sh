check_aur_dependencies() {
    # Set 'ring' that is used for recursive dependencies
    # i.e. 'element-desktop' > depends on 'element-web' > depends on 'electron'
    # We would first need to build 'electron' and add to the local repository, followed by 'element-web', followed by 'element-desktop'
    export aur_ring_num="0"
    export aur_ring_${aur_ring_num}="${PKG}"

    # Keep looping until 'aur_ring_${aur_ring_num}' is empty
    while [[ $(eval echo \${aur_ring_${aur_ring_num}}) != "" ]]; do

        # Add 1 to ring number - needed by some commands to add packages to next ring
        export temp_aur_ring_num=$(( "${aur_ring_num}" + 1 ))

        export db_packages=$(cat /etc/mpm/sources.db)

        # Check each package specified in 'aur_ring_${aur_ring_num}'
        for i in $(eval echo \${aur_ring_${aur_ring_num}}); do

            local db_results=$(makedeb-db --package ${i} | jq -r .aur_packages | grep -vw "null")

            # Add packages to build list if not in database (i.e. not installed)
            for j in ${db_results}; do

                # TODO: This will cause issue if there's two packages that end the same way in the database (i.e. 'cheese' was specified, and both 'cheese' and 'burgcheese' exist)
                if ! echo ${db_packages} | grep "${j}\\" &> /dev/null; then
                    export aur_ring_${temp_aur_ring_num}+="${i}"
                fi
            done
        done

        # Sets 'aur_ring_num' to the value of 'temp_aur_ring_num' for next run of loop (if packages were added)
        export aur_ring_num=${temp_aur_ring_num}
    done
}
