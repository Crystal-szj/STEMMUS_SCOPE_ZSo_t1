function [DataPaths, forcingFileName, durationSize, startDate, endDate, gsOption, phsOption, RunningMessages, paraFile] = read_config(config_file)

    file_id = fopen(config_file);
    config = textscan(file_id,'%s %s', 'HeaderLines',0, 'Delimiter', '=');
    fclose(file_id);

    %% separate vars and paths
    config_vars = config{1};
    config_paths = config{2};

    %% find the required path by model
    indx = find(strcmp(config_vars, 'SoilPropertyPath'));
    DataPaths.soilProperty = config_paths{indx};

    indx = find(strcmp(config_vars, 'InputPath'));
    DataPaths.input = config_paths{indx};

    indx = find(strcmp(config_vars, 'OutputPath'));
    DataPaths.output = config_paths{indx};

    indx = find(strcmp(config_vars, 'ForcingPath'));
    DataPaths.forcingPath = config_paths{indx};

    indx = find(strcmp(config_vars, 'ForcingFileName'));
    forcingFileName = config_paths{indx};

    indx = find(strcmp(config_vars, 'InitialConditionPath'));
    DataPaths.initialCondition = config_paths{indx};

    % value of DurationSize is optional and can be NA
    indx = find(strcmp(config_vars, 'DurationSize'));
    durationSize = str2double(config_paths{indx});
    
    % set start date and end date
    indx = find(strcmp(config_vars,'StartDate'));
    startDate = config_paths{indx};

    indx = find(strcmp(config_vars,'EndDate'));
    endDate = config_paths{indx};

    indx = find(strcmp(config_vars, 'gsOption'));
    if isempty(indx)
        gsOption = [];
    else
        gsOption = config_paths{indx};
    end
    
    indx = find(strcmp(config_vars, 'phsOption'));
    phsOption = str2double(config_paths{indx});
%     if isempty(indx)
%         phsOption = [];
%     else
%         phsOption = config_paths{indx};
%     end
    
    indx = find(strcmp(config_vars,'RunningMessages'));
    if ~isempty(indx)
        RunningMessages = config_paths{indx};
    end
    
    indx = find(strcmp(config_vars,'ParameterSettingPath'));
    paraFile = config_paths{indx};
end