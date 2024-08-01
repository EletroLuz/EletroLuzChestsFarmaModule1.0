local expiration_time = 10
local is_interacting = false
local interaction_end_time = 0
local interactedObjects = {}

local function matches_any_pattern(name, patterns)
    for _, pattern in ipairs(patterns) do
        if name:match(pattern) then
            return true
        end
    end
    return false
end

local function move_to_and_interact(obj)
    local player_pos = get_player_position()
    local obj_pos = obj:get_position()

    local distanceThreshold = 2.0
    local moveThreshold = 12.0

    local distance = obj_pos:dist_to(player_pos)
    
    if distance < distanceThreshold then
        is_interacting = true
        local obj_key = obj:get_skin_name() .. "_" .. obj:get_id()
        interactedObjects[obj_key] = os.clock() + expiration_time
        interact_object(obj)
        console.print("Interacting with " .. obj:get_skin_name())
        interaction_end_time = os.clock() + 5
        return true
    elseif distance < moveThreshold then
        pathfinder.request_move(obj_pos)
        return false
    end
end

local function interact_with_objects(doorsEnabled)
    local local_player = get_local_player()
    if not local_player then
        return
    end

    local objects = actors_manager.get_ally_actors()
    local interactive_patterns = { "usz_reward", "usz_rewardGizmo_", "Reward", "aChestOpen", "aHelltideChestO", "Chest" }

    for _, obj in ipairs(objects) do
        if obj then
            local obj_id = obj:get_id()
            local obj_name = obj:get_skin_name()
            local obj_key = obj_name .. "_" .. obj_id

            if obj_name and matches_any_pattern(obj_name, interactive_patterns) then
                if doorsEnabled and (not interactedObjects[obj_key] or os.clock() > interactedObjects[obj_key]) then
                    if move_to_and_interact(obj) then
                        return
                    end
                end
            end
        end
    end
end

local function check_interaction()
    if is_interacting and os.clock() > interaction_end_time then
        is_interacting = false
        console.print("Interaction complete, resuming movement.")
    end
end

return {
    interact_with_objects = interact_with_objects,
    check_interaction = check_interaction
}