import os
from PyStemmusScope import StemmusScope
from pathlib import Path
from PyStemmusScope import config_io
from PyStemmusScope import utils
import argparse


def run_model_sensitivity_analysis(parameter_file_index, job_id):
    # user must provide the correct path
    path_to_config_file ='/media/geo/Crystal/P1/sensitivity_analysis_CLM5_scheme/STEMMUS_SCOPE_SS/run_model_on_snellius/config_file_snellius_sensitivity_analysis.txt'
    path_to_exe_file  = '/media/geo/Crystal/P1/sensitivity_analysis_CLM5_scheme/STEMMUS_SCOPE_SS/run_model_on_snellius/exe/STEMMUS_SCOPE_SS'

    # # Set LD_LIBRARY_PATH in pycharm
    # bash_command = 'whereis MATLAB'
    # matlab_path = os.popen(bash_command).read()
    # matlab_path = matlab_path.split(": ")[1]
    # matlab_path = matlab_path.split("\n")[0]
    #
    # os.environ['LD_LIBRARY_PATH'] = (
    #     f"{matlab_path}/MATLAB_Runtime/v910/runtime/glnxa64:"
    #     f"{matlab_path}/MATLAB_Runtime/v910/bin/glnxa64:"
    #     f"{matlab_path}/MATLAB_Runtime/v910/sys/os/glnxa64:"
    #     f"{matlab_path}/MATLAB_Runtime/v910/extern/bin/glnxa64:"
    #     f"{matlab_path}/MATLAB_Runtime/v910/sys/opengl/lib/glnxa64")
    # print(os.environ['LD_LIBRARY_PATH'])

    # create an instance of the model
    model = StemmusScope(config_file=path_to_config_file, model_src_path=path_to_exe_file)

    # get the parameter file
    parameter_filenames_list = [
        file.name for file in Path(model.config["ParameterSettingPath"]).iterdir()
    ]

    # update parameter file information
    parameter_filename = parameter_filenames_list[parameter_file_index -1]
    parameter_setting_path = model.config["ParameterSettingPath"] + parameter_filename
    model.config["ParameterSettingPath"] = parameter_setting_path

    # setup the model
    # here you can change the location and start & end time
    station_name = "CH-HTC"
    config_path = model.setup(
        Location=station_name,
        StartTime="2022-01-01T00:00",
        EndTime="2022-01-02T01:30",
    )

    # update config_file
    config_path_dir = utils.to_absolute_path(config_path)
    with config_path_dir.open(mode="w", encoding="utf8") as f:
        for key, value in model.config.items():
            if key == "ParameterSettingPath":
                update_entry = f"{key}={str(model.config['ParameterSettingPath'])}\n"
            if key == "OutputPath":
                model.config['OutputPath'] = model.config['OutputPath'][0:-23]
                update_entry = f"{key}={str(model.config['OutputPath'])}\n"

            else:
                update_entry = f"{key}={value}\n"
            f.write(update_entry)

    # # new config file generated to run the model
    # print(f"New config file {config_path}")
    #
    # # see input and output paths generated by the model
    # print(f'Model input dir {model.config["InputPath"]}')
    # print(f'Model output dir {model.config["OutputPath"]}')
    # print(f'Model parameter setting {model.config["ParameterSettingPath"]}')
    # print(f'Model exe file{model.exe_file}')
    # print(f'Model cfg file{model.cfg_file}')

    # run the model
    model_log = model.run()

    slurm_log_msg = [
        f"Input path is {model.config['InputPath']}",
        f"Output path is {model.config['OutputPath']}",
        f"model log is {model_log}",
        # f"model outputs are in {netcdf_file_name}",
    ]
    slurm_file_name = (
        Path(model.config["OutputPath"])
        / f"slurm_{job_id}_{parameter_file_index}_{station_name}.out"
    )
    slurm_log(slurm_file_name, slurm_log_msg)

def slurm_log(slurm_file_name, slurm_log_msg):
    """Create slurm log file for the submitted job."""
    with open(slurm_file_name, "w+", encoding="utf-8") as file:
        for line in slurm_log_msg:
            file.write(line)
            file.write("\n")

if __name__ =="__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "-n",
        "--parameter_file_index",
        required=True,
        type=int,
        default=0,
        help="index of input parameter file",
    )
    parser.add_argument(
        "-j",
        "--job_id",
        required=True,
        type=int,
        default=0,
        help="slurm job id from snellius",
    )

    # get arguments
    args = parser.parse_args()

    run_model_sensitivity_analysis(args.parameter_file_index, args.job_id)

