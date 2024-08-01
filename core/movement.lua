local waypoints = {}
local ni = 1
local is_moving = false

local function get_distance(point)
    return get_player_position():dist_to(point)
end

local function pulse()
    if not is_moving then
        return
    end

    if ni > #waypoints or #waypoints == 0 then
        return
    end

    local current_waypoint = waypoints[ni]
    if get_distance(current_waypoint) < 1 then
        ni = ni + 1
    else
        pathfinder.request_move(current_waypoint)
    end
end

return {
    pulse = pulse,
    set_waypoints = function(new_waypoints) waypoints = new_waypoints end,
    start_moving = function() is_moving = true end,
    stop_moving = function() is_moving = false end
}