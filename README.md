# cori-gpu-report

An example to show CUPTI API does not work on cori-gpu nodes.

# Reproduce steps

    module load esslurm
    salloc -C gpu -N 1 -t 30 -c 10 --gres=gpu:1 -A m1759
    make
    ulimit -c unlimited
    srun ./pc_sampling
