function [DataPaths, forcingFileName, durationSize, Options, Scenario] = read_config(config_file)

    file_id = fopen(config_file);
    config = textscan(file_id,'%s %s', 'HeaderLines',0, 'Delimiter', '=');
    fclose(file_id);

    %% separate vars and paths
    config_vars = config{1};
    config_data = config{2};

    %% find the required path by model
    indx = find(strcmp(config_vars, 'SoilPropertyPath'));
    DataPaths.soilProperty = config_data{indx};

    indx = find(strcmp(config_vars, 'InputPath'));
    DataPaths.input = config_data{indx};

    indx = find(strcmp(config_vars, 'OutputPath'));
    DataPaths.output = config_data{indx};

    indx = find(strcmp(config_vars, 'ForcingPath'));
    DataPaths.forcingPath = config_data{indx};

    indx = find(strcmp(config_vars, 'ForcingFileName'));
    forcingFileName = config_data{indx};

    indx = find(strcmp(config_vars, 'InitialConditionPath'));
    DataPaths.initialCondition = config_data{indx};

    % value of DurationSize is optional and can be NA
    indx = find(strcmp(config_vars, 'DurationSize'));
    durationSize = str2double(config_data{indx});
    
    
    %% set options
    % calculate the complete energy balance
    index = find(strcmp(config_vars,'calc_ebal'))
    Options.calc_ebal = config_data{index};
    
    % calculate vertical profiles of fluxes and temperatures
    index = find(strcmp(config_vars,'calc_vert_profiles'))
    Options.calc_vert_profiles = config_data{index};    
    
    % calculate chlorophyll fluorescence
    index = find(strcmp(config_vars,'calc_fluor'))
    Options.calc_fluor = config_data{index};

    % calculate spectrum of thermal radiation with spectral emissivity instead of broadband
    index = find(strcmp(config_vars,'calc_planck'))
    Options.calc_planck = config_data{index};
     
    % calculate BRDF and directional temperature for many angles specified in a file. Be patient, this takes some time
    index = find(strcmp(config_vars,'calc_directional'))
    Options.calc_directional = config_data{index};

    % calculate dynamic xanthopyll absorption (zeaxanthin), for simulating PRI
    index = find(strcmp(config_vars,'calc_xanthophyllabs'))
    Options.calc_xanthophyllabs = config_data{index};

    % 0 (recommended): treat the whole fluorescence spectrum as one spectrum (new calibrated optipar), 
    % 1: differentiate PSI and PSII with Franck et al. spectra (of SCOPE 1.62 and older)
    index = find(strcmp(config_vars,'calc_PSI'))
    Options.calc_PSI = config_data{index};

    % 0: provide emissivity values as input. 
    % 1: use values from fluspect and soil at 2400 nm for the TIR range
    index = find(strcmp(config_vars,'rt_thermal'))
    Options.rt_thermal = config_data{index};

    % 0: use the zo and d values provided in the inputdata, 
    % 1: calculate zo and d from the LAI, canopy height, CD1, CR, CSSOIL (recommended if LAI changes in time series)
    index = find(strcmp(config_vars,'calc_zo'))
    Options.calc_zo = config_data{index};
    

    % 0: use soil spectrum from a file, 
    % 1: simulate soil spectrum with the BSM model
    index = find(strcmp(config_vars,'soilspectrum'))
    Options.soilspectrum = config_data{index};

    % 0: standard calculation of thermal inertia from soil characteristics, 
    % 1: empiricaly calibrated formula (make function), 
    % 2: as constant fraction of soil net radiation
    index = find(strcmp(config_vars,'soil_heat_method'))
    Options.soil_heat_method = config_data{index};

    % 0: empirical, with sustained NPQ (fit to Flexas' data); 
    % 1: empirical, with sigmoid for Kn; 2: Magnani 2012 model
    index = find(strcmp(config_vars,'Fluorescence_model'))
    Options.Fluorescence_model = config_data{index};

    % 0: use resistance rss and rbs as provided in inputdata. 
    % 1:  calculate rss from soil moisture content and correct rbs for LAI (calc_rssrbs.m)
    index = find(strcmp(config_vars,'calc_rss_rbs'))
    Options.Xcalc_rss_rbs = config_data{index};

    % correct Vcmax and rate constants for temperature in biochemical.m
    index = find(strcmp(config_vars,'apply_T_corr'))
    Options.apply_T_corr = config_data{index};

    % verifiy the results (compare to saved 'standard' output) to test the code for the first ime
    index = find(strcmp(config_vars,'verify'))
    Options.verify = config_data{index};
    
    % write header lines in output files
    index = find(strcmp(config_vars,'save_headers'))
    Options.save_headers = config_data{index};
    
    % plot the results
    index = find(strcmp(config_vars,'makeplots'))
    Options.makeplots = config_data{index};
    
    % 0: individual runs. Specify one value for constant input, and an equal number (>1) of values for all input that varies between the runs.
    index = find(strcmp(config_vars,'simulation'))
    Options.makeplots = config_data{index};
    
%     index = find(strcmp(config_vars,'gs_method'))
%     Options.gs_method = config_data{index};

    indx = find(strcmp(config_vars, 'Scenario'));
        if isempty(indx)
            Scenario = [];
        else
            Scenario = config_data{indx};
        end
end