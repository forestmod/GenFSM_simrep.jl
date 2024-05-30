using Test, GenFSM_simrep

include("Test_utilities.jl")
def_settings = load_settings()
@test def_settings["simulation_region"]["cres_epsg_id"] == 3035
@test isfile(def_settings["res"]["ft_list"])
#def_settings = load_settings(override=["scenario_path"=>"dummy"])