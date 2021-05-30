check_arch_dependencies() {
    # Set 'ring' that is used for recursive dependencies
    # i.e. 'element-desktop' > depends on 'element-web' > depends on 'electron'
    # We would first need to build 'electron' and add to the local repository, followed by 'element-web', followed by 'element-desktop'
    export arch_ring_num="0"
    export arch_ring_${arch_ring_num}="${PKG}"

    # Read packages from package database
    export db_packages=$(cat /etc/mpm/sources.db)


    # Keep looping until 'arch_ring_${arch_ring_num}' is empty
    while [[ "$(eval echo \${arch_ring_${arch_ring_num}})" != "" ]]; do

        # Add 1 to ring number - needed by some commands to add packages to next ring
        export temp_arch_ring_num=$(( "${arch_ring_num}" + 1 ))

        # Check each package specified in 'arch_ring_${arch_ring_num}'
        for i in $(eval echo \${arch_ring_${arch_ring_num}}); do

            local db_results=$(makedeb-db --package ${i} | jq -r .arch_packages | grep -vw "null")

            # Add packages to build list if not in database (i.e. not installed)
            for j in ${db_results}; do

                # TODO: This will cause issue if there's two packages that end the same way in the database (i.e. 'cheese' was specified, and both 'cheese' and 'burgcheese' exist)
                if ! echo ${db_packages} | grep "${j}\\" &> /dev/null; then
                    export arch_ring_${temp_arch_ring_num}+=" ${j}"

                    # Add to global dependency list; used for "extra packages" in install_pkg()
                    export arch_dependency_packages+=" ${j}"
                fi
            done
        done

        # Sets 'arch_ring_num' to the value of 'temp_arch_ring_num' for next run of loop (if packages were added)
        export arch_ring_num=${temp_arch_ring_num}
    done
}
