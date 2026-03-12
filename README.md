# slurmitout
(cc0) 2026-03-12, <seung-goo.kim@ae.mpg.de> 

## what is this?
It's a lazy workaround of writing `sbatch` scripts for old-timers who still use MATLAB. This is from an internal repo (`ncml-code`), and mainly for MPIEAers[^1].



## what is `sbatch`?
It's a [Slurm](https://slurm.schedmd.com/documentation.html) command to submit an array of jobs (up to 1000) to run in parallel on your [HPC cluster](https://en.wikipedia.org/wiki/High-performance_computing) server.

## how do i use it?
### 0. Download this repo and path it in MATLAB.

Let's say you just want to download it and extract it in your home directory on your HPC. Once you log in your HPC (either SSH or VNC terminal), copy and paste the line below into your shell prompt ($) and press Enter.
```bash
wget https://github.com/seunggookim/slurmitout/archive/refs/heads/main.zip && unzip main.zip && rm main.zip
```
The above will create a directory `~/slurmitout-main`.

Now, open an MATLAB (i.e., open an interactive session and load a MATLAB module environment), and add this path by copying and pasting the line blow in the MALTAB prompt (>>) and press Enter.
```matlab
addpath ~/slurmitout-main
```

From here, the prompt character indices which script language you're supposed to type (or copy-and-paste) into. $ means bash. >> means MATLAB.

### 1. Test on your account
If you see no warning message, then let's run a small test:
```matlab
>> cd ~/slurmitout-main/test/
>> test
```

This script runs 10 jobs to sleep 1 to 10 seconds in parallel. How do we see which jobs are running for me?
```bash
$ squeue --me
```

Each job say something into their command windows. How do we see what they are saying?
```bash
$ cat ~/slurm/0001/*_1.out
```
This will print out the first job in the the first batch said. Why "0001"? Just a serial number in your log folder `~/slurm`. It is independent from the Slurm job ID. 


## how do i really use it for my work?

### 0. syntax
If you take a look at the `test.m`:
```matlab
jobs = {};
for i = 1:10
  jobs{i} = struct('minutes',i/60);
end
dnLog = slurmitout(@sleepfor, jobs);
```
you'll notice that the basic syntax is:
```
slurmitout(FUNCTION_HANDLE, CELL_ARRAY_WITH_JOBS)
```

### 1. your script
Say you want to run some process over 50 subjects. Then your script may look like this:
```matlab
addpath MY_TOOLBOX
load THAT_DATA
EVERYTHING = [];
for iSubj = 1:50
  load (['THIS_DATA_',num2str(iSubj)], 'THIS_DATA')
  THIS_OUTPUT = dothis(THAT_DATA, THIS_DATA);
  EVERYTHING = [EVERYTTHING; THIS_OUTPUT];
end
```

### 2. helper function (or "wrapper")
First you need to create a helper function that gets `job` structure as an input and run just one subject. Let's say `job.iSubj` is the only field you use:
```matlab
function myhelper(job)
addpath MY_TOOLBOX
load THAT_DATA
load (['THIS_DATA_',num2str(job.iSubj)], 'THIS_DATA')
THIS_OUTPUT = dothis(THAT_DATA, THIS_DATA);
save ('THIS_OUTPUT_',num2str(job.iSubj)], 'THIS_OUTPUT')
end
```
and save this as a `myhelper.m` in your project directory.

### 3. slurm it out
Now you need to create a script that calls `slurmitout`. But, before submit 50 subjects, it is always good to test if this helper function really works:
```matlab
jobs = {};
for iSubj = 1:50
  jobs = [jobs, struct('iSubj', iSubj)];
end
myhelper(jobs{1})  % test run for the first subject
%slurmitout(@myhelper, jobs)  % not yet.
```

If the helper function works fine then go ahead and run everything:
```matlab
jobs = {};
for iSubj = 1:50
  jobs = [jobs, struct('iSubj', iSubj)];
end
%myhelper(jobs{1})  % test run for the first subject
slurmitout(@myhelper, jobs) % now submit all 50 subjects
```


## compatibility
**OS/language**: This function assumes that you're using a MATLAB on a Linux because you're supposed on a HPC server with Slurm.

**MATLAB versions**: It's tested on R2018a, R2020b, R2024b, R2025b

## why it doesn't work for me?
(this section is reserved for future trouble-shooting)

---
[^1]: I'm too lazy to change the default partition name (`octopus`)... but you can change it in `cfg.Partition='your-partition-name'`.
