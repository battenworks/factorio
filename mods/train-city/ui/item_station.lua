require("ui.station_gui")

local item_type = "item"
local gui_name = "bwtc_item_station_gui"
local selection_button_name = "bwtc_item_station_selection_button"
local direction_switch_name = "bwtc_item_station_direction_switch"

item_station_gui = {
	name = gui_name,
	selection_button_name = selection_button_name,
	direction_switch_name = direction_switch_name,
}

item_station_gui.toggle = function (player, entity)
	station_gui.toggle(player, entity, item_type, gui_name, selection_button_name, direction_switch_name)
end

item_station_gui.clear = function (player)
	station_gui.clear(player)
end

item_station_gui.configure_train_station = function (player)
	station_gui.configure_train_station(player, item_type)
end
