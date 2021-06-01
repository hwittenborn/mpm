# This file is copy-pasted from build_arch_dependencies.sh, with all instances of 'arch' replaces with 'arch'

build_arch_dependencies() {
    # Check for and build arch dependencies
    if [[ "${arch_ring_num}" -gt "0" ]]; then

        # Set current ring number
        export arch_build_ring_num="${arch_ring_num}"

        # Build each ring's packages, and add them to the local repository
        while [[ "${arch_build_ring_num}" -gt "0" ]]; do

            for j in $( eval echo \${arch_ring_${arch_build_ring_num}} ); do
                build_package ${j} arch_dependency
            done

            export arch_build_ring_num=$(( "${arch_build_ring_num}" - 1 ))
        done
    fi
}
