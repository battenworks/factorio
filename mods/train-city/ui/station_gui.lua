require("ui.common")
require("ui.station_behavior")

station_gui = {}

local function new(player, global_player, entity, item_type, gui_name, button_name, switch_name)
	local selected_item, selected_direction = parse_selection_and_direction(entity.backer_name, item_type)

	local main_window = player.gui.screen.add{ type = "frame", direction = "vertical" }
	main_window.name = gui_name
	main_window.auto_center = true

	player.opened = main_window
	global_player.elements.station_gui = main_window
	global_player.entities.station_entity = entity

	local title_bar_caption = { "entity-name.bwtc-" .. item_type .. "-station" }
	add_title_bar_to_gui(title_bar_caption, main_window)

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
