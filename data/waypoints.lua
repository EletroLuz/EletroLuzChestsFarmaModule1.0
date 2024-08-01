local helltide_tps = {
    {name = "Frac_Tundra_S", id = 0xACE9B, file = "menestad"},
    {name = "Scos_Coast", id = 0x27E01, file = "marowen"},
    {name = "Kehj_Oasis", id = 0xDEAFC, file = "ironwolfs"},
    {name = "Hawe_Verge", id = 0x9346B, file = "wejinhani"},
    {name = "Step_South", id = 0x462E2, file = "jirandai"}
}

local function load_waypoints(file)
    if file == "wejinhani" then
        waypoints = require("waypoints.wejinhani")
        console.print("Loaded waypoints: wejinhani")
    elseif file == "marowen" then
        waypoints = require("waypoints.marowen")
        console.print("Loaded waypoints: marowen")
    elseif file == "menestad" then
        waypoints = require("waypoints.menestad")
        console.print("Loaded waypoints: menestad")
    elseif file == "jirandai" then
        waypoints = require("waypoints.jirandai")
        console.print("Loaded waypoints: jirandai")
    elseif file == "ironwolfs" then
        waypoints = require("waypoints.ironwolfs")
        console.print("Loaded waypoints: ironwolfs")
    else
        console.print("No waypoints loaded")
    end
end

return {
    helltide_tps = helltide_tps,
    load_waypoints = load_waypoints
}