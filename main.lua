-- Import menu elements
local menu = require("menu")
local waypoints_data = require("data.waypoints")
local helltide_tps = waypoints_data.helltide_tps
local load_waypoints = waypoints_data.load_waypoints

local interaction = require("core.interaction")
local movement = require("core.movement")
local teleport = require("core.teleport")
local cinders = require("tasks.cinders")
local helltide = require("tasks.helltide")

-- Inicializa as variáveis
local plugin_enabled = false
local doorsEnabled = false

-- Função chamada periodicamente para interagir com objetos
on_update(function()
    if plugin_enabled then
        if teleport.is_teleporting() then
            teleport.handle_teleport()
        else
            local local_player = get_local_player()
            if helltide.is_in_helltide(local_player) then
                interaction.check_interaction()
                interaction.interact_with_objects(doorsEnabled)
                cinders.start_movement_and_check_cinders()
            else
                teleport.attempt_teleport()
            end
        end
    end
end)

-- Função para renderizar o menu
on_render_menu(function()
    if menu.main_tree:push("Helltide Farmer (EletroLuz)-V1.0") then
        local enabled = menu.plugin_enabled:get()
        if enabled ~= plugin_enabled then
            plugin_enabled = enabled
            if plugin_enabled then
                console.print("Movement Plugin enabled")
                helltide.check_and_load_waypoints()
            else
                console.print("Movement Plugin disabled")
            end
        end
        menu.plugin_enabled:render("Enable Movement Plugin", "Enable or disable the movement plugin")

        local enabled_doors = menu.main_openDoors_enabled:get() or false
        if enabled_doors ~= doorsEnabled then
            doorsEnabled = enabled_doors
            if doorsEnabled then
                console.print("Open Chests Plugin enabled")
            else
                console.print("Open Chests Plugin disabled")
            end
        end
        menu.main_openDoors_enabled:render("Open Chests", "Enable or disable the chest plugin")

        menu.main_tree:pop()
    end
end)