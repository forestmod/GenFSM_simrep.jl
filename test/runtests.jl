using Test, GenFSM_simrep

def_settings = load_settings()
@test def_settings["simulation_region"]["cres_epsg_id"] == 3035
@test isfile(def_settings["ft_list"])
