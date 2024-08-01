local waypoints_data = require("data.waypoints")
local helltide_tps = waypoints_data.helltide_tps
local load_waypoints = waypoints_data.load_waypoints

local function is_in_helltide(local_player)
    local buffs = local_player:get_buffs()
    for _, buff in ipairs(buffs) do
        if buff.name_hash == 1066539 then
            return true
        end
    end
    return false
end

local function check_and_load_waypoints()
    local world_instance = world.get_current_world()
    if world_instance then
        local zone_name = world_instance:get_current_zone_name()

        for _, tp in ipairs(helltide_tps) do
            if zone_name == tp.name then
                load_waypoints(tp.file)
                current_city_index = tp.id
                return
            end
        end
        console.print("No matching city found for waypoints")
    end
end

return {
    is_in_helltide = is_in_helltide,
    check_and_load_waypoints = check_and_load_waypoints
}