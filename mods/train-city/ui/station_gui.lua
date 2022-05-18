require("ui.common")
require("ui.station_behavior")

station_gui = {}

local function new(player, global_player, entity, item_type, gui_name, button_name, switch_name)
	local selected_item, selected_direction = parse_selection_and_direction(entity.backer_name, item_type)

	local main_window = player.gui.center.add{
		type = "frame",
		name = gui_name,
		caption = { "entity-name.bwtc-" .. item_type .. "-station" },
		style = "bwtc_gui_main_window",
	}

	player.opened = main_window
	global_player.elements.station_gui = main_window
	global_player.entities.station_entity = entity

	local main_container = main_window.add{
		type = "frame",
		name = "main_container",
		direction = "vertical",
		style = "inside_shallow_frame_with_padding",
	}
	local selection_container = main_container.add{
		type = "flow",
		name = "selection_container",
		direction = "horizontal",
		style = "bwtc_station_selection_container",
	}
	selection_container.add{
		type = "label",
		caption = { "bwtc." .. item_type .. "-caption" },
	}
	local choose_item_button = selection_container.add{
		type = "choose-elem-button",
		name = button_name,
		elem_type = item_type,
	}
	choose_item_button.elem_value = selected_item
	local direction_container = main_container.add{
		type = "flow",
		name = "direction_container",
		direction = "horizontal",
		style = "bwtc_station_direction_container",
	}
	direction_container.add{
		type = "label",
		caption = { "bwtc.drop-caption" },
	}
	direction_container.add{
		type = "switch",
		name = switch_name,
		switch_state = selected_direction,
	}
	direction_container.add{
		type = "label",
		caption = { "bwtc.load-caption" },
	}
end

station_gui.toggle = function (player, entity, item_type, gui_name, button_name, switch_name)
	station_gui.name = gui_name
	station_gui.selection_button_name = button_name
	station_gui.direction_switch_name = switch_name

	local global_player = global_player.get(player)
	local global_gui = global_player.elements.station_gui

	if global_gui == nil then
		new(player, global_player, entity, item_type, gui_name, button_name, switch_name)
	else
		global_gui.destroy()
		global_player.elements = {}
		global_player.entities = {}
	end
end

station_gui.clear = function (player)
	local global_player = global_player.get(player)

	if global_player.elements.station_gui ~= nil then
		station_gui.toggle(player)
	end
end

station_gui.configure_train_station = function (player, item_type)
	local global_player = global_player.get(player)
	local global_gui = global_player.elements.station_gui
	local train_station = global_player.entities.station_entity
	local selected_item_name = global_gui.main_container.selection_container[station_gui.selection_button_name].elem_value or "none"
	local switch_direction = global_gui.main_container.direction_container[station_gui.direction_switch_name].switch_state
	local selected_direction = switch_direction == "left" and "drop" or "load"

	if is_already_associated_with_an_item(train_station.backer_name, item_type) then
		local associated_trains = find_all_trains_associated_with_station(train_station.backer_name)

		if #associated_trains > 0 then
			old_schedule = associated_trains[1].schedule
		end

		set_new_train_station_configuration(train_station, selected_item_name, item_type, selected_direction)
		reassociate_trains_with_old_schedule(associated_trains, old_schedule)
	else
		set_new_train_station_configuration(train_station, selected_item_name, item_type, selected_direction)
	end
end
