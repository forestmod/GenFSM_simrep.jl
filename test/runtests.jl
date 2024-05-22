using Test, MrFOR_simrep

def_settings = load_settings()
@test def_settings["simulation_region"]["cres_epsg_id"] == 3035

a = "\${SCENARIO_PATH}/forest_types.txt"
replace!(a,"\${SCENARIO_PATH}" => "/some/path")

adic = Dict("a"=>1,"b"=>2,"c"=>3)

plusone(x) = x+1

map((k,v) -> plusone(v), adic)

for (k,v) in adic
    plusone(v)
end