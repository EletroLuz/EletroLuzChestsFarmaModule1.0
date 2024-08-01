local movement = require("core.movement")

local check_interval = 60
local start_time = 0

local function start_movement_and_check_cinders()
    if not movement.is_moving() then
        start_time = os.clock()
        movement.start_moving()
    end

    if os.clock() - start_time > check_interval then
        movement.stop_moving()
        local cinders_count = get_helltide_coin_cinders()

        if cinders_count == 0 then
            console.print("No cinders found. Stopping movement to teleport.")
            local player_pos = get_player_position()
            pathfinder.request_move(player_pos)
            
            if not is_loading_screen() then
                current_city_index = (current_city_index % #helltide_tps) + 1
                teleport_to_waypoint(helltide_tps[current_city_index].id)
                teleporting = true
                next_teleport_attempt_time = os.clock() + 15
            else
                console.print("Currently in loading screen. Waiting before attempting teleport.")
                next_teleport_attempt_time = os.clock() + 10
            end
        else
            console.print("Cinders found. Continuing movement.")
        end
    end

    movement.pulse()
end

return {
    start_movement_and_check_cinders = start_movement_and_check_cinders
}