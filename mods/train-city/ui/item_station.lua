require("ui.station_gui")

local item_type = "item"

item_station = {
	name = item_station.window_name,
	selection_button_name = item_station.selection_button_name,
	direction_switch_name = item_station.direction_switch_name,
}

item_station.toggle = function (player, entity)
	item_station.toggle(player, entity, item_type)
end

item_station.clear = function (player)
	item_station.clear(player)
end

item_station.configure_train_station = function (player)
	item_station.configure_train_station(player, item_type)
end
