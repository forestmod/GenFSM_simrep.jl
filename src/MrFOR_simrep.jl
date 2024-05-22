"""
    MrFOR_simrep

Simulation settings repository for MrFOR models.

This package sole function is [`load_settings`](@ref).

The settings are stored in this repository as yaml files in:

- [project]
  - scenarios
    - [scenario]

Where the default project and the default scenarios ae both named "default".
"""
module MrFOR_simrep

using YAML
export load_settings



#rep = joinpath(@__DIR__,"..","repository")
#dicts2nt(x) = x
#dicts2nt(d::Dict) = (; (Symbol(k) => dicts2nt(v) for (k, v) in d)...)

"""
    load_settings(project="default",scenario="default")

Load the settings for a specific project and scenario.
The settings are returned as a dictionary.
"""
function load_settings(project="default",scenario="default")
    rep_path = joinpath(@__DIR__,"..","repository")
    project_path = joinpath(rep_path,project)
    scenario_path = joinpath(project_path,"scenarios",scenario)
    settings_path = joinpath(scenario_path,"settings.yaml")
    settings = YAML.load_file(settings_path)
    return settings
end

end # module MrFOR_simrep
