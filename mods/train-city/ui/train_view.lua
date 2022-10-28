require("ui.common")
require("ui.train_behavior")

train_view = {}

local function new(player, global_player, entity, item_type, view_name, button_name)
	selected_item = train_behavior.parse_selected_item(entity.train.schedule, item_type)

	local main_window = player.gui.screen.add{ type = "frame", direction = "vertical" }
	main_window.name = view_name
	main_window.auto_center = true

	player.opened = main_window
	global_player.elements.train_view = main_window
	global_player.entities.train_entity = entity.train

	local title_bar_caption = { "entity-name.bwtc-" .. item_type .. "-train" }
	common.add_title_bar_to_view(title_bar_caption, main_window)

	local main_container = main_window.add{ type = "frame", direction = "vertical" }
	main_container.name = "main_container"
	main_container.style = "inside_shallow_frame"

	local selection_container = main_container.add{ type = "flow", direction = "horizontal" }
	selection_container.name = "selection_container"
	selection_container.style = "bwtc_train_selection_container"

	local selection_label = selection_container.add{ type = "label" }
	selection_label.caption = { "bwtc." .. item_type .. "-caption" }

	local selection_button = selection_container.add{ type = "choose-elem-button", elem_type = item_type }
	selection_button.name = button_name
	selection_button.elem_value = selected_item

	local station_header = main_container.add{ type = "frame", direction = "horizontal" }
	station_header.name = "station_header"
	station_header.style = "bwtc_train_station_header"

	local station_label = station_header.add{ type = "label" }
	station_label.caption = { "bwtc.stations-caption" }
	station_label.style = "bwtc_train_station_header_label"

	local station_list_container = main_container.add{ type = "frame", direction = "vertical" }
	station_list_container.name = "station_list_container"
	station_list_container.style = "inside_shallow_frame_with_padding"

	if entity.train.schedule then
		train_behavior.render_station_list(station_list_container, entity.train.schedule)
	else
		local station_list_label = station_list_container.add{ type = "label" }
		station_list_label.caption = "None"
	end
end

train_view.toggle = function (player, entity, item_type, view_name, button_name)
	train_view.name = view_name
	train_view.selection_button_name = button_name

	local global_player = common.get_global_player(player)
	local global_view = global_player.elements.train_view

	if global_view == nil then
		new(player, global_player, entity, item_type, view_name, button_name)
	else
		global_view.destroy()
		global_player.elements = {}
		global_player.entities = {}
	end
end

train_view.clear = function (player)
	local global_player = common.get_global_player(player)

	if global_player.elements.train_view ~= nil then
		train_view.toggle(player)
	end
end

train_view.configure_train = function (player)
	local global_player = common.get_global_player(player)
	local global_view = global_player.elements.train_view
	local selected_item = global_view.main_container.selection_container[train_view.selection_button_name].elem_value or "none"

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

	train_behavior.render_station_list(global_view.main_container.station_list_container, schedule)

	local train = global_player.entities.train_entity
	train.schedule = schedule
	train.manual_mode = false

	if train.locomotives["front_movers"][1].burner.inventory.is_empty() then
		train.locomotives["front_movers"][1].burner.inventory.insert("rocket-fuel")
	end
end
