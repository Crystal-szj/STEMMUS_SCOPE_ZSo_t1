%%%%%%% A function to run STEMMUS_SCOPE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function STEMMUS_SCOPE_SS_exe(config_file, parameter_setting_file)

% disable all warnings 
warning('off','all')

% set the global variable CFG
CFG = config_file;
paraFile = parameter_setting_file;

% run STEMMUS_SCOPE main code
run STEMMUS_SCOPE_SS