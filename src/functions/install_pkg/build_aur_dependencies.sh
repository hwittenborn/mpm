build_aur_dependencies() {
    # Check for and build AUR dependencies
    if [[ "${aur_ring_num}" -gt "1" ]]; then

        # Set current ring number
        export aur_build_ring_num="1"

        # Build each ring's packages, and add them to the local repository
        while [[ "${aur_build_ring_num}" -le "${aur_ring_num}" ]]; do

            for j in $( eval echo \${aur_ring_${aur_build_ring_num}} ); do
                build_package ${j} aur_dependency
            done

            export aur_build_ring_num=$(( "${aur_build_ring_num}" + 1 ))
        done
    fi
}
