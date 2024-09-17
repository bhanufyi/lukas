# Execution Instructions

```bash
cd lukas
ponyc
./lukas 1000000 4
```

## Benchmark Analysis

```bash
./benchmark.sh 1000000 4 100
```

Runs 100 iterations of the benchmark with n = 1000000 and k = 4 with varying chunk sizes.

## Observations

### Iterations and Chunk Sizes

- The benchmark was executed over **100 iterations** for various **chunk sizes**: 128, 256, 512, and 1024.
- Each iteration records the real time (`real`), user time (`user`), system time (`sys`), and the calculated number of cores used.

### Performance by Chunk Size

- **Chunk Size 128**:
  - Higher real and user times compared to larger chunk sizes.
  - The number of cores used fluctuates between **4 and 7**, but the CPU is not fully utilized.

- **Chunk Size 256**:
  - Cores used range from **5 to 8**, with some peaks at 7.66 cores.
  - More efficient than chunk size 128 but still not consistently using the full CPU.

- **Chunk Size 512**:
  - Cores used consistently range from **5 to 10**.
  - Several iterations reach full CPU utilization, peaking at 10 cores, though some drops as low as 4.5 indicate variability.

- **Chunk Size 1024**:
  - The most efficient chunk size with core usage between **4 and 9**.
  - It shows high stability, frequently utilizing close to the maximum number of CPU cores.

### Cores Used

- **Chunk sizes 512 and 1024** consistently show the highest and most efficient core utilization.
  - They often reach full utilization (10 cores in some iterations).
- **Chunk sizes 128 and 256** tend to underutilize the available CPU resources, with lower and more variable core usage.

### Execution Times

- **Real times** decrease with larger chunk sizes, with chunk size 1024 achieving the lowest times (as low as 0.01 seconds).
- **User times** also decrease as chunk size increases, leading to improved performance for larger chunks.

### Variability

- **Chunk size 512** shows the most variability, sometimes utilizing all CPU resources effectively, but other times underperforming.
- **Chunk sizes 128 and 256** show more frequent fluctuations in core usage, suggesting less stable performance.

## Conclusions

- **Best Overall Performance**: Chunk sizes **512** and **1024** offer the best performance, frequently utilizing the maximum number of cores.
- **Inconsistent Core Utilization**: Smaller chunk sizes (128 and 256) underutilize CPU cores, leading to inefficient execution.
- **Peak Efficiency**: Iterations with chunk sizes **512** and **1024** achieve the fastest execution times and highest CPU core utilization.

In summary, chunk sizes **512** and **1024** provide optimal parallelism and performance, while smaller chunk sizes may lead to lower efficiency and inconsistent core utilization.
