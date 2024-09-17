#!/bin/bash

# Check if at least 3 arguments (N, K, and number of iterations) are provided
if [ "$#" -lt 3 ]; then
  echo "Usage: $0 N K iterations"
  exit 1
fi

# Read N, K, and number of iterations from command line arguments
N=$1
K=$2
ITERATIONS=$3
EXECUTABLE="./lukas"

# Check if the executable exists and is executable
if [ ! -x "$EXECUTABLE" ]; then
  echo "Error: $EXECUTABLE not found or is not executable."
  exit 1
fi

# Array of chunk sizes to try
CHUNK_SIZES=(128 256 512 1024)

# Output file to store benchmark results
OUTPUT_FILE="benchmark_results.txt"
echo "Benchmark Results" > $OUTPUT_FILE
echo "N=$N, K=$K, Iterations=$ITERATIONS" >> $OUTPUT_FILE

# Loop for running the entire benchmark n times
for ITER in $(seq 1 $ITERATIONS); do
  echo -e "\nIteration $ITER:\n" | tee -a $OUTPUT_FILE

  # Loop over chunk sizes and run the benchmark for each chunk size
  for CHUNK in "${CHUNK_SIZES[@]}"
  do
    echo -e "\nRunning with chunk size: $CHUNK (Iteration $ITER)\n" | tee -a $OUTPUT_FILE
    
    # Run time command and capture output to a temporary file
    TEMP_FILE=$(mktemp)
    { /usr/bin/time -p $EXECUTABLE $N $K $CHUNK; } 2> $TEMP_FILE
    
    # Append the captured output (numbers and timing) to the output file
    cat $TEMP_FILE | tee -a $OUTPUT_FILE

    # Extract timing information from the temporary file
    REAL_TIME=$(grep real $TEMP_FILE | awk '{print $2}')
    USER_TIME=$(grep user $TEMP_FILE | awk '{print $2}')
    SYS_TIME=$(grep sys $TEMP_FILE | awk '{print $2}')
    
    # Convert the real, user, and sys times from the format (seconds only)
    REAL_TIME=$(echo "$REAL_TIME" | awk '{print $1}')
    USER_TIME=$(echo "$USER_TIME" | awk '{print $1}')
    SYS_TIME=$(echo "$SYS_TIME" | awk '{print $1}')

    # Prevent divide by zero by checking if real time is greater than zero
    if (( $(echo "$REAL_TIME > 0" | bc -l) )); then
      # Calculate the number of cores used
      CORES_USED=$(echo "scale=2; ($USER_TIME + $SYS_TIME) / $REAL_TIME" | bc)
      echo -e "\nChunk size: $CHUNK, Cores used: $CORES_USED\n" | tee -a $OUTPUT_FILE
    else
      echo -e "\nChunk size: $CHUNK, Cores used: Calculation skipped (Real Time too low)\n" | tee -a $OUTPUT_FILE
    fi

    echo "---------------------------------" >> $OUTPUT_FILE
    echo -e "\n"  # Add space between each chunk log
    
    # Remove the temporary file
    rm -f $TEMP_FILE
  done
done

echo "Benchmarking complete. Results stored in $OUTPUT_FILE"
