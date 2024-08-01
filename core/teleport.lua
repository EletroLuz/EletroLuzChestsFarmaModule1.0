local waypoints_data = require("data.waypoints")
local helltide_tps = waypoints_data.helltide_tps
local load_waypoints = waypoints_data.load_waypoints

local teleporting = false
local next_teleport_attempt_time = 0
local loading_start_time = nil
local current_city_index = 1

local function is_loading_screen()
    local world_instance = world.get_current_world()
    if world_instance then
        local zone_name = world_instance:get_current_zone_name()
        return zone_name == nil or zone_name == ""
    end
    return true
end

local function is_teleporting()
    return teleporting
end

local function handle_teleport()
    local current_time = os.clock()
    local current_world = world.get_current_world()
    if not current_world then
        return
    end

    if current_world:get_name():find("Limbo") then
        if not loading_start_time then
            loading_start_time = current_time
        end
        return
    else
        if loading_start_time and (current_time - loading_start_time) < 4 then
            return
        end
        loading_start_time = nil
    end

    if not is_loading_screen() then
        local world_instance = world.get_current_world()
        if world_instance then
            local zone_name = world_instance:get_current_zone_name()
            if zone_name == helltide_tps[current_city_index].name then
                load_waypoints(helltide_tps[current_city_index].file)
                ni = 1
                teleporting = false
            elseif os.clock() > next_teleport_attempt_time then
                console.print("Teleport failed, retrying...")
                teleport_to_waypoint(helltide_tps[current_city_index].id)
                next_teleport_attempt_time = os.clock() + 30
            end
        end
    end
end

local function attempt_teleport()
    console.print("Not in Helltide zone. Attempting to teleport.")
    current_city_index = (current_city_index % #helltide_tps) + 1
    teleport_to_waypoint(helltide_tps[current_city_index].id)
    teleporting = true
    next_teleport_attempt_time = os.clock() + 15
end

return {
    is_teleporting = is_teleporting,
    handle_teleport = handle_teleport,
    attempt_teleport = attempt_teleport
}