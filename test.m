clear; restoredefaultpath;
addpath('../')
jobs = {};
for i = 1:10
  jobs{i} = struct('seconds',i);
end
dnLog = slurmitout(@sleepfor, jobs);
assert(numel(dir([dnLog,'/*out']))==10)
disp('TEST: PASS! ^o^)/')
