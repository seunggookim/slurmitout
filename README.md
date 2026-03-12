# slurmitout
(cc0) 2026, <seung-goo.kim@ae.mpg.de> 

## what is this?
It's a lazy workaround of writing `sbatch` script for old-timers who still use MATLAB. This is from an internal repo (`ncml-code`).

## what is `sbatch`?
It's a [Slurm](https://slurm.schedmd.com/documentation.html) command to submit an array of jobs to run in parallel on your [HPC cluster](https://en.wikipedia.org/wiki/High-performance_computing) server.

## how do i use it?
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

**MATLAB versions**: It's tested on R2018a, R2024b, R2025b

## why it doesn't work for me?

- It says, ``

  + If you try to run 1000+ jobs, use `slurmmanyout()`.

- It says, ``

  + 

