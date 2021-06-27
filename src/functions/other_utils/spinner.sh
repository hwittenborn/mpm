spinner() {
    printf '    '
    while [[ -d "/proc/${process_id}" ]]; do
        printf '\b\b\b[|]'
        sleep 0.1
        printf '\b\b\b[/]'
        sleep 0.1
        printf '\b\b\b[-]'
        sleep 0.1
        printf '\b\b\b[\\]'
        sleep 0.1
    done
    printf '\b\b\b   \n'
    sleep 0.2
}
