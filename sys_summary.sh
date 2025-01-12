#!/bin/bash

# Function to handle errors
error() {
    echo "Error: $1" >&2
    exit 1
}

# Function to verify correctness
correct() { 
    [ "$(cat $BENCHMARK.hash | cut -d' ' -f 2 | grep -c 1)" -eq 0 ]
}

profile_run() {
    local benchmark_name="$1"
    local output_prefix="$2"

    echo "Profiling ./run.sh for $benchmark_name..."

    # Profile `./run.sh` with strace
    strace -c -o "${output_prefix}_strace.txt" ./run.sh --small || error "Failed to run $benchmark_name"

    # Run `run.sh` in the background
    ./run.sh --small &
    local pid=$!

    # Wait briefly to ensure the process is running
    sleep 1

    # Check if the process is still running and capture file descriptors
    if [[ -d /proc/$pid ]]; then
        lsof -p "$pid" > "${output_prefix}_lsof.txt"
    else
        echo "Warning: Process $pid ended before lsof could capture file descriptors."
        > "${output_prefix}_lsof.txt"  # Create an empty file to avoid errors
    fi

    # Wait for the process to complete
    wait "$pid"

    # Extract and display total system calls from strace output
    local total_syscalls
    total_syscalls=$(awk '/^100.00/ {print $4}' "${output_prefix}_strace.txt")
    echo "Total system calls for $benchmark_name: $total_syscalls"

    # Summarize lsof output
    if [[ -s "${output_prefix}_lsof.txt" ]]; then
        local fd_count
        fd_count=$(wc -l < "${output_prefix}_lsof.txt")
        echo "Total open file descriptors for $benchmark_name: $fd_count"
    else
        echo "No file descriptors captured for $benchmark_name."
    fi

    echo "Finished profiling ./run.sh for $benchmark_name."
}


main() {
    export BENCHMARK="$1"
    shift

    # Navigate to the benchmark directory
    cd "$(dirname "$0")/$BENCHMARK" || exit 1

    # Ensure dependencies and inputs are set up
    ./deps.sh "$@" || error "Failed to download dependencies for $BENCHMARK"
    ./input.sh "$@" || error "Failed to fetch inputs for $BENCHMARK"

    # Output directory for profiling results
    OUTPUT_DIR="./profiling_results"
    mkdir -p "$OUTPUT_DIR"
    local output_prefix="${OUTPUT_DIR}/${BENCHMARK}"

    # Profile `run.sh`
    profile_run "$BENCHMARK" "$output_prefix"

    # Verify output (optional, can be skipped if unnecessary)
    ./verify.sh "$@" > "$BENCHMARK.hash" || error "Failed to verify output for $BENCHMARK"

    # Cleanup outputs (optional, can be skipped if unnecessary)
    ./cleanup.sh "$@"

    # Print benchmark pass/fail status
    if correct; then
        echo "$BENCHMARK [pass]"
    else
        error "$BENCHMARK [fail]"
    fi

    # Return to the original directory
    cd - > /dev/null || exit 1
}

main "$@"
