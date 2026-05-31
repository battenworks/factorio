require("ui.common")
require("ui.station_behavior")

station_view = {}

local function new(player, storage_player, entity, item_type, view_name, button_name, switch_name)
	local selected_item, selected_direction = station_behavior.parse_selection_and_direction(entity.backer_name, item_type)

	local main_window = player.gui.screen.add {
		type = "frame",
		name = view_name,
		direction = "vertical",
	}
	main_window.auto_center = true

	player.opened = nil
	player.opened = main_window
	storage_player.elements.station_view = main_window
	storage_player.entities.station_entity = entity

	common.add_title_bar_to_view({ "entity-name.bwbd-" .. item_type .. "-station" }, main_window)

	local main_container = main_window.add {
		type = "frame",
		name = "main_container",
		direction = "vertical",
		style = "inside_shallow_frame_with_padding",
	}

	local selection_container = main_container.add {
		type = "flow",
		name = "selection_container",
		direction = "horizontal",
		style = "bwbd_station_selection_container",
	}

	selection_container.add {
		type = "label",
		caption = { "bwbd." .. item_type .. "-caption" },
	}

	local choose_item_button = selection_container.add {
		type = "choose-elem-button",
		name = button_name,
		elem_type = item_type,
	}
	choose_item_button.elem_value = selected_item

	local direction_container = main_container.add {
		type = "flow",
		name = "direction_container",
		direction = "horizontal",
		style = "bwbd_station_direction_container",
	}

	direction_container.add {
		type = "label",
		caption = { "bwbd.drop-caption" },
	}

	direction_container.add {
		type = "switch",
		name = switch_name,
		switch_state = selected_direction,
	}

	direction_container.add {
		type = "label",
		caption = { "bwbd.load-caption" },
	}

	local priority_container = main_container.add {
		type = "flow",
		name = "priority_container",
		direction = "horizontal",
		style = "bwbd_station_priority_container",
	}

	priority_container.add {
		type = "label",
		caption = { "bwbd.priority-caption" },
	}

	priority_container.add {
		type = "checkbox",
		name = "priority_checkbox",
		state = station_behavior.is_station_priority(entity),
		tooltip = { "bwbd.priority-tooltip" },
	}
end

station_view.toggle = function(player, entity, item_type, view_name, button_name, switch_name)
	station_view.name = view_name
	station_view.selection_button_name = button_name
	station_view.direction_switch_name = switch_name

	local storage_player = common.get_storage_player(player)
	local storage_view = storage_player.elements.station_view

	if storage_view == nil then
		new(player, storage_player, entity, item_type, view_name, button_name, switch_name)
	else
		storage_view.destroy()
		storage_player.elements = {}
		storage_player.entities = {}
	end
end

station_view.clear = function(player)
	local storage_player = common.get_storage_player(player)

	if storage_player.elements.station_view ~= nil then
		station_view.toggle(player)
	end
end

station_view.configure_train_station = function(player, item_type)
	local storage_player = common.get_storage_player(player)
	local storage_view = storage_player.elements.station_view
	local train_station = storage_player.entities.station_entity
	local selected_item_name = storage_view.main_container.selection_container[station_view.selection_button_name].elem_value or "none"
	local switch_direction = storage_view.main_container.direction_container[station_view.direction_switch_name].switch_state
	local selected_direction = switch_direction == "left" and "drop" or "load"

	if station_behavior.is_already_associated_with_an_item(train_station.backer_name, item_type) then
		local associated_trains = station_behavior.find_all_trains_associated_with_station(train_station.backer_name)

		if #associated_trains > 0 then
			old_schedule = associated_trains[1].schedule
		end

		station_behavior.set_new_train_station_configuration(train_station, selected_item_name, item_type, selected_direction)
		station_behavior.reassociate_trains_with_old_schedule(associated_trains, old_schedule)
	else
		station_behavior.set_new_train_station_configuration(train_station, selected_item_name, item_type, selected_direction)
	end
end
