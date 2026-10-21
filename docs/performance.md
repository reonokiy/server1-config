# Initial performance screening

Measured on 2026-10-22 (Asia/Singapore), before installing the fan driver.

| Measurement | Result |
| --- | ---: |
| OpenSSL SHA-256, one worker, 16 KiB blocks, 8 seconds | 2.75 GB/s |
| OpenSSL SHA-256, 32 workers, 16 KiB blocks, 180 seconds | 63.5 GB/s |
| CPU utilization during sustained run | 100% |
| CPU idle / peak | 38 / 72.9 °C |
| CPU after 30 seconds cooldown | 40 °C |
| Single-process memory copy | 21.7 GiB/s |
| Memory comparison | Full 4 GiB comparison passed |
| SSD direct sequential write, 4 GiB | 4.6 GB/s |
| SSD direct sequential read, 4 GiB | 7.4 GB/s |
| SSD peak temperature across run | 42.9 °C |

Memory workload allocated 8 GiB total and copied 32 GiB across eight passes. SSD testing used a temporary regular file with direct I/O; the file was removed. CPU governor was `powersave` with boost enabled. OpenSSL version was 4.0.3.

All subprocesses completed successfully; no thermal cutoff fired (CPU 90 °C, SSD 80 °C). This short screening does not establish full-memory integrity, long-duration SSD write speed, or worst-case vector-load cooling. Fan speeds were not available during this run.
