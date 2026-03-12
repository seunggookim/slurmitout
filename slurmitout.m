function dnLog = slurmitout(funcHandle, jobs, initCmd, initSh, cfg)
%DnLog = slurmitout(funcHandle, jobs, initCmd, initSh, Cfg)
%
% e.g.
% initCmd = 'addpath /my/local/path; myfunc_addpath';
% initSh  = 'source ~/.bashrc';
%
% funcHandle  (1 x 1)      MATLAB function handle
% jobs        {nJobs x 1}  Jobs in a cell array
% initCmd     '1 x nChar'  A one-lined MATLAB command to run before run the given function (default='')
% initSh      '1 x nChar'  A one-lined Shell command to run before open MATLAB (default='source ~/.bashrc')
%
% cfg         [1 x 1]      SLURM configuration switches
% .nTasks     [1 x 1]      The number of tasks per job (default=1)
% .Mem_GB     [1 x 1]      Memory per node in GB (default=8)
% .Partition  '1 x nChar'  Partition name in SLURM (default='octopus')
% .IsWait     [1 x 1]      --wait switch (default=true) | false
% .Switch     '1 x nChar'  Additional SLURM switches
%
% (cc) 2022-2023, dr.seunggoo.kim@gmail.com

funcInfo = functions(funcHandle);
assert(~isempty(funcInfo.file), '"%s" is not pathed.', funcHandle)
assert(iscell(jobs), 'Jobs should be a cell array!')
tStart = tic;
if ~exist('InitCmd','var')||isempty(initCmd); initCmd=''; end
if ~exist('InitSh','var')||isempty(initSh); initSh='source ~/.bashrc'; end
if ~exist('Cfg','var')||isempty(cfg); cfg = struct(); end
[dnLog, jobId] = findslurmlogpath();

%% Save Job files
for iJob = 1:numel(jobs)
  Job = jobs{iJob};
  FnameJob = [dnLog,filesep,'Job_',num2str(iJob),'.mat'];
  save(FnameJob,'Job')
end

%% Create runme.sh
fnameSh = fullfile(dnLog,'runme.sh');
defaultCfg = struct('Partition','octopus', 'CpuPerTask',1, 'nTasks',1, 'Mem_GB',5, 'IsWait',true, 'Time','14-0:00',...
  'Switch','');
cfg = defaultcfg(defaultCfg, cfg, mfilename);
fprintf('\n')

fid = fopen(fnameSh,'w');
fprintf(fid, '#!/bin/bash\n');
fprintf(fid, '#SBATCH --job-name=%s_%s\n', jobId, funcInfo.function);
FuncPath = fileparts(funcInfo.file);
fprintf(fid, '#SBATCH --chdir=%s\n', FuncPath);
fprintf(fid, '#SBATCH --output=%s/%s_%%A_%%a.out\n', dnLog, funcInfo.function);
fprintf(fid, '#SBATCH --array=1-%i\n', numel(jobs));
fprintf(fid, '#SBATCH --partition=%s\n', cfg.Partition);
fprintf(fid, '#SBATCH --ntasks=%i\n', cfg.nTasks);
fprintf(fid, '#SBATCH --cpus-per-task=%i\n', cfg.CpuPerTask);
fprintf(fid, '#SBATCH --mem=%iG\n', cfg.Mem_GB);
fprintf(fid, '#SBATCH --time=%s\n', cfg.Time);
fprintf(fid, '#SBATCH %s\n', cfg.Switch); % additional switches
fprintf(fid, '%s\n', initSh);
fprintf(fid, [...
  'matlab -nodisplay -r "%s; ',...           % open MATLAB
  'load %s_${SLURM_ARRAY_TASK_ID}.mat; ',... % load the i-th job file
  'try; %s(Job); ',...                       % run that job file
  'catch ME; disp(''***ERROR***:''); disp(ME); disp(''STACK:''); disp({ME.stack.name}); ',... % show error msg
  'end; exit;"\n'],...  
  initCmd, [dnLog,filesep,'Job'], funcInfo.function);
fclose(fid);

%% Submit it
logthis('Running %s: %i jobs via SLURM\n', func2str(funcHandle), numel(jobs))
if cfg.IsWait
  system(['sbatch --wait ',fnameSh]);
  logthis('DONE: %s\n',  char(duration(seconds(toc(tStart)), 'Format','hh:mm:ss.SSS')));
else
  system(['sbatch ',fnameSh]);
end
logthis('Check out SLURM outputs: "%s"\n\n', dnLog);

end
