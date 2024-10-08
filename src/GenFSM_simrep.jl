"""
    GenFSM_simrep

Simulation settings repository for GenFSM models.

This package sole function is [`load_settings`](@ref).

The settings are stored in this repository as yaml files in:

- [project]
  - scenarios
    - [scenario]

Where the default project and the default scenarios ae both named "default".
"""
module GenFSM_simrep

using YAML, DelimitedFiles
export load_settings

include("Utils.jl")

"""
    load_settings(project="default",scenario="default")

Load the settings for a specific project and scenario.
The settings are returned as a dictionary.
"""
function load_settings(project="default",scenario="default";override=[])
    rep_path      = joinpath(@__DIR__,"..","repository")
    project_path  = joinpath(rep_path,project)
    scenario_path = joinpath(project_path,"scenarios",scenario)
    caller_path   = pwd()

    # Adding name and path of the region/scenarios to the settings, so that they can be overridden in command line
    settings = Dict{Any,Any}(
        "project"=>project,
        "scenario"=>scenario,
        "project_path"=>project_path,
        "scenario_path"=>scenario_path,
        "caller_path"=>caller_path,
    )

    override_nested_dict!(settings,override) # override settings from command line

    # Make sure that, if project_path and scenario_path have been overritten with relative paths, these are back absolute paths like caller_path (if they are NOT been overritten they are already abs paths)
    isabspath(settings["project_path"]) || (settings["project_path"] = joinpath(caller_path,settings["project_path"]))
    isabspath(settings["scenario_path"]) || (settings["scenario_path"] = joinpath(caller_path,settings["scenario_path"]))
    project_path  = settings["project_path"]
    scenario_path = settings["scenario_path"]

    ENV["SCENARIO_PATH"] = scenario_path
    #settings_general      = YAML.load_file(joinpath(scenario_path,"settings.yaml"))
    #settings_resources    = Dict("res"=>YAML.load_file(joinpath(scenario_path,"res","settings_resources.yaml")))
    #settings = merge(settings_general, settings_resources)
    settings      =  merge(settings,YAML.load_file(joinpath(scenario_path,"settings.yaml")))
    settings["res"] = YAML.load_file(joinpath(scenario_path,"res","settings_res.yaml"))
    recursive_replace!(settings,"\${SCENARIO_PATH}" => scenario_path)

    ft_list = convert(Vector{String},readdlm(settings["res"]["ft_list"],';')[:,1])
    settings["res"]["ft"] = ft_list
    settings["simulation_region"]["nx"] = Int(ceil((settings["simulation_region"]["x_ub"] - settings["simulation_region"]["x_lb"]) / settings["simulation_region"]["xres"])) 
    settings["simulation_region"]["ny"] = Int(ceil((settings["simulation_region"]["y_ub"] - settings["simulation_region"]["y_lb"]) / settings["simulation_region"]["yres"]))
    settings["res"]["nft"] = size(ft_list,1)
    settings["res"]["ndc"] = length(settings["res"]["dc"])


   # Saving absolute output paths and making them if they do not exist:
   isabspath(settings["temp_path"]) || (settings["temp_path"] = joinpath(caller_path,settings["temp_path"]))
   isabspath(settings["cache_path"]) || (settings["cache_path"] = joinpath(caller_path,settings["cache_path"]))
   isabspath(settings["output_path"]) || (settings["output_path"] = joinpath(caller_path,settings["output_path"]))
   isdir(settings["temp_path"]) || mkpath(settings["temp_path"])
   isdir(settings["cache_path"]) || mkpath(settings["cache_path"])
   isdir(settings["output_path"]) || mkpath(settings["output_path"])


    # Loading res region specific settings
    for reg in settings["res"]["regions"]
        settings["res"][reg] = YAML.load_file(joinpath(scenario_path,"res","settings_res_$(reg).yaml"))
    end
    return settings
end

end # module GenFSM_simrep
