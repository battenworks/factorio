require("ui.station_gui")

local item_type = "item"

item_station_gui = {
	name = station_gui.name,
	selection_button_name = station_gui.selection_button_name,
	direction_switch_name = station_gui.direction_switch_name,
}

item_station_gui.toggle = function (player, entity, gui_name)
	station_gui.toggle(player, entity, item_type)
end

item_station_gui.clear = function (player)
	station_gui.clear(player)
end

item_station_gui.configure_train_station = function (player)
	station_gui.configure_train_station(player, item_type)
end
