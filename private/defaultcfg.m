function cfg = defaultcfg(defaultCfg, cfg, procName, IsVerbose)
%defaultcfg check input fields and set them to default values
%
% cfg = defaultjob(defaultCfg, cfg, [ProcName], [IsVerbose])
%
% (cc) 2021, sgKIM.

if not(exist('IsVerbose','var')), IsVerbose=true; end
if exist('procName','var')
  procName = ['[',procName, '] '];
else
  procName = '';
end

fldNames = fieldnames(defaultCfg);
for iFld = 1:numel(fldNames)
  if ~isfield(cfg, fldNames{iFld})
    value = defaultCfg.(fldNames{iFld});
    if IsVerbose
      fprintf('%s(DEFAULT) cfg.%s = ', procName, fldNames{iFld});
      if numel(value) > 10
        fprintf('<%s %i x %i> ...', class(value), size(value));
        disp(value(end-5:end)); 
      else
        disp(value);
      end
      if not(contains(class(value), {'string','char'}))
        fprintf('\b');
      end
      if isempty(value) || isequal(value,"")
        fprintf('\n');
      end
    end
    cfg.(fldNames{iFld}) = value;
  end
end

end
