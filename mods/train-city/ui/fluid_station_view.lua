require("ui.station_view")

local item_type = "fluid"
local view_name = "bwtc_fluid_station_view"
local selection_button_name = "bwtc_fluid_station_selection_button"
local direction_switch_name = "bwtc_fluid_station_direction_switch"

fluid_station_view = {
	name = view_name,
	selection_button_name = selection_button_name,
	direction_switch_name = direction_switch_name,
}

fluid_station_view.toggle = function(player, entity)
	station_view.toggle(player, entity, item_type, view_name, selection_button_name, direction_switch_name)
end

fluid_station_view.clear = function(player)
	station_view.clear(player)
end

fluid_station_view.configure_train_station = function(player)
	station_view.configure_train_station(player, item_type)
end
