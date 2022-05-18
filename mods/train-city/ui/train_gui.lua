require("ui.common")
require("ui.train_behavior")

train_gui = {}

local function new(player, global_player, entity, item_type, gui_name, button_name)
	selected_item = parse_selected_item(entity.train.schedule, item_type)

	local main_window = player.gui.center.add{
		type = "frame",
		name = gui_name,
		caption = { "entity-name.bwtc-" .. item_type .. "-train" },
		style = "bwtc_gui_main_window",
	}

	player.opened = main_window
	global_player.elements.train_gui = main_window
	global_player.entities.train_entity = entity.train

	local main_container = main_window.add{
		type = "frame",
		name = "main_container",
		direction = "vertical",
		style = "inside_shallow_frame",
	}
	local selection_container = main_container.add{
		type = "flow",
		name = "selection_container",
		direction = "horizontal",
		style = "bwtc_train_selection_container",
	}
	selection_container.add{
		type = "label",
		caption = { "bwtc." .. item_type .. "-caption" },
	}
	local selection_button = selection_container.add{
		type = "choose-elem-button",
		name = button_name,
		elem_type = item_type,
	}
	selection_button.elem_value = selected_item
	local station_header = main_container.add{
		type = "frame",
		name = "station_header",
		direction = "horizontal",
		style = "bwtc_train_station_header",
	}
	station_header.add{
		type = "label",
		caption = { "bwtc.stations-caption" },
		style = "bwtc_train_station_header_label",
	}
	local station_list_container = main_container.add{
		type = "frame",
		name = "station_list_container",
		direction = "vertical",
		style = "inside_shallow_frame_with_padding",
	}
	if entity.train.schedule then
		render_station_list(station_list_container, entity.train.schedule)
	else
		station_list_container.add{
			type = "label",
			caption = "None",
		}
	end
end

train_gui.toggle = function (player, entity, item_type, gui_name, button_name)
	train_gui.name = gui_name
	train_gui.selection_button_name = button_name

	local global_player = global_player.get(player)
	local global_gui = global_player.elements.train_gui

	if global_gui == nil then
		new(player, global_player, entity, item_type, gui_name, button_name)
	else
		global_gui.destroy()
		global_player.elements = {}
		global_player.entities = {}
	end
end

train_gui.clear = function (player)
	local global_player = global_player.get(player)

	if global_player.elements.train_gui ~= nil then
		train_gui.toggle(player)
	end
end

train_gui.configure_train = function (player)
	local global_player = global_player.get(player)
	local global_gui = global_player.elements.train_gui
	local selected_item = global_gui.main_container.selection_container[train_gui.selection_button_name].elem_value or "none"

	local full_wait_condition = {
		type = "full",
		compare_type = "or"
	}
	local empty_wait_condition = {
		type = "empty",
		compare_type = "or"
	}
	local inactivity_wait_condition = {
		type = "inactivity",
		ticks = 5 * 60,
		compare_type = "or"
	}
	local time_wait_condition = {
		type = "time",
		ticks = 1 * 60,
		compare_type = "or"
	}
	local schedule = {
		current = 1,
		records = {
			{
				station = selected_item .. " load",
				wait_conditions = {
					full_wait_condition,
					inactivity_wait_condition,
				}
			},
			{
				station = "fuel",
				wait_conditions = {
					time_wait_condition,
				}
			},
			{
				station = selected_item .. " drop",
				wait_conditions = {
					empty_wait_condition,
					inactivity_wait_condition,
				}
			},
			{
				station = "fuel",
				wait_conditions = {
					time_wait_condition,
				}
			},
		}
	}

	render_station_list(global_gui.main_container.station_list_container, schedule)

	local train = global_player.entities.train_entity
	train.schedule = schedule
	train.manual_mode = false

	if train.locomotives["front_movers"][1].burner.inventory.is_empty() then
		train.locomotives["front_movers"][1].burner.inventory.insert("rocket-fuel")
	end
end
