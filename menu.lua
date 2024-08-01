-- Define a etiqueta do plugin
local plugin_label = "CAMINHADOR_PLUGIN_"

-- Cria os elementos do menu
local menu_elements = {
    plugin_enabled = checkbox:new(false, get_hash(plugin_label .. "plugin_enabled")),
    main_openDoors_enabled = checkbox:new(false, get_hash(plugin_label .. "main_openDoors_enabled")),
    main_tree = tree_node:new(0),
}

-- Retorna os elementos do menu
return menu_elements