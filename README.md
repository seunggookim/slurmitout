# slurmitout
(cc0) 2026, <seung-goo.kim@ae.mpg.de> 

## what is this?
It's a lazy workaround of writing `sbatch` scripts for old-timers who still use MATLAB. This is from an internal repo (`ncml-code`), and mainly for MPIEAers[^1].



## what is `sbatch`?
It's a [Slurm](https://slurm.schedmd.com/documentation.html) command to submit an array of jobs (up to 1000) to run in parallel on your [HPC cluster](https://en.wikipedia.org/wiki/High-performance_computing) server.

## how do i use it?
0. Download this repo and path it in MATLAB.


1. Prepare your helper function and a cell array of jobs.



2. Submit it.
```matlab
>> slurmitout(@yourHelperFunction, yourJobs)
```

3. Check the outputs while running.


4. When it's all done, check if everything is done fine! (If not, debug your functions and rerun everything [as always]).

## examples


## compatibility
**OS/language**: This function assumes that you're using a MATLAB on a Linux because you're supposed on a HPC server with Slurm.

**MATLAB versions**: It's tested on R2018a, R2020b, R2024b, R2025b

## why it doesn't work for me?

- I have more than 1000 jobs to run!

  + Try `slurmmanyout()`.

- It says, ``

  + 

- I have more than 


---
[^1]: I'm too lazy to change the default partition name (`octopus`)... but you can change it in `cfg.Partition='your-partition-name'`.
