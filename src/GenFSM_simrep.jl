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



#rep = joinpath(@__DIR__,"..","repository")
#dicts2nt(x) = x
#dicts2nt(d::Dict) = (; (Symbol(k) => dicts2nt(v) for (k, v) in d)...)

recursive_replace!(obj,replacement_pattern) = obj
recursive_replace!(obj::AbstractArray,replacement_pattern)  = recursive_replace!.(obj::AbstractArray,Ref(replacement_pattern))
recursive_replace!(obj::AbstractString,replacement_pattern) = replace(obj,replacement_pattern)
function recursive_replace!(obj::AbstractDict,replacement_pattern)
    for (k,v) in obj
        obj[k] = recursive_replace!(v,replacement_pattern)
    end
    return obj
end

"""
    load_settings(project="default",scenario="default")

Load the settings for a specific project and scenario.
The settings are returned as a dictionary.
"""
function load_settings(project="default",scenario="default")
    rep_path      = joinpath(@__DIR__,"..","repository")
    project_path  = joinpath(rep_path,project)
    scenario_path = joinpath(project_path,"scenarios",scenario)
    settings_path = joinpath(scenario_path,"settings.yaml")
    ENV["SCENARIO_PATH"] = scenario_path
    settings      = YAML.load_file(settings_path)
    recursive_replace!(settings,"\${SCENARIO_PATH}" => scenario_path)
    ft_list = convert(Vector{String},readdlm(settings["ft_list"],';')[:,1])
    settings["ft"] = ft_list
    settings["simulation_region"]["nx"] = Int(ceil((settings["simulation_region"]["x_ub"] - settings["simulation_region"]["x_lb"]) / settings["simulation_region"]["xres"])) 
    settings["simulation_region"]["ny"] = Int(ceil((settings["simulation_region"]["y_ub"] - settings["simulation_region"]["y_lb"]) / settings["simulation_region"]["yres"]))
    settings["nft"] = size(ft_list,1)
    settings["ndc"] = length(settings["dc"])
    return settings
end

end # module GenFSM_simrep
