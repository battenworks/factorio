require("ui.station_gui")

local item_type = "fluid"

fluid_station_gui = {
	name = station_gui.name,
	selection_button_name = station_gui.selection_button_name,
	direction_switch_name = station_gui.direction_switch_name,
}

fluid_station_gui.toggle = function (player, entity)
	station_gui.toggle(player, entity, item_type)
end

fluid_station_gui.clear = function (player)
	station_gui.clear(player)
end

fluid_station_gui.configure_train_station = function (player)
	station_gui.configure_train_station(player, item_type)
end
