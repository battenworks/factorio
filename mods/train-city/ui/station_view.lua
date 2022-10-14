require("ui.common")
require("ui.station_behavior")

station_view = {}

local function new(player, global_player, entity, item_type, view_name, button_name, switch_name)
	local selected_item, selected_direction = station_behavior.parse_selection_and_direction(entity.backer_name, item_type)

	local main_window = player.view.screen.add{ type = "frame", direction = "vertical" }
	main_window.name = view_name
	main_window.auto_center = true

	player.opened = main_window
	global_player.elements.station_view = main_window
	global_player.entities.station_entity = entity

	local title_bar_caption = { "entity-name.bwtc-" .. item_type .. "-station" }
	common.add_title_bar_to_view(title_bar_caption, main_window)

	local main_container = main_window.add{ type = "frame", direction = "vertical" }
	main_container.name = "main_container"
	main_container.style = "inside_shallow_frame_with_padding"

	local selection_container = main_container.add{ type = "flow", direction = "horizontal" }
	selection_container.name = "selection_container"
	selection_container.style = "bwtc_station_selection_container"

	local selection_label = selection_container.add{ type = "label" }
	selection_label.caption = { "bwtc." .. item_type .. "-caption" }

	local choose_item_button = selection_container.add{ type = "choose-elem-button", elem_type = item_type }
	choose_item_button.name = button_name
	choose_item_button.elem_value = selected_item

	local direction_container = main_container.add{ type = "flow", direction = "horizontal" }
	direction_container.name = "direction_container"
	direction_container.style = "bwtc_station_direction_container"

	local direction_drop_label = direction_container.add{ type = "label" }
	direction_drop_label.caption = { "bwtc.drop-caption" }

	local direction_switch = direction_container.add{ type = "switch" }
	direction_switch.name = switch_name
	direction_switch.switch_state = selected_direction

	local direction_load_label = direction_container.add{ type = "label" }
	direction_load_label.caption = { "bwtc.load-caption" }
end

station_view.toggle = function (player, entity, item_type, view_name, button_name, switch_name)
	station_view.name = view_name
	station_view.selection_button_name = button_name
	station_view.direction_switch_name = switch_name

	local global_player = common.get_global_player(player)
	local global_view = global_player.elements.station_view

	if global_view == nil then
		new(player, global_player, entity, item_type, view_name, button_name, switch_name)
	else
		global_view.destroy()
		global_player.elements = {}
		global_player.entities = {}
	end
end

station_view.clear = function (player)
	local global_player = common.get_global_player(player)

	if global_player.elements.station_view ~= nil then
		station_view.toggle(player)
	end
end

station_view.configure_train_station = function (player, item_type)
	local global_player = common.get_global_player(player)
	local global_view = global_player.elements.station_view
	local train_station = global_player.entities.station_entity
	local selected_item_name = global_view.main_container.selection_container[station_view.selection_button_name].elem_value or "none"
	local switch_direction = global_view.main_container.direction_container[station_view.direction_switch_name].switch_state
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
