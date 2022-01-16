require("ui.common")

local window_name = "bwtc_item_train_gui"
local choose_elem_button_name = "bwtc_item_train_selected_item"

item_train = {
	name = window_name,
	selected_item_control = choose_elem_button_name,

	render_station_list = function (container, schedule)
		container.clear()
		local station_list = container.add{
			type = "table",
			column_count = 1,
		}
		for _, record in pairs(schedule.records) do
			station_list.add{
				type = "label",
				caption = record.station,
				style = "bwtc_item_train_station_line_item",
			}
		end
	end,

	new = function (player, global_player, entity)
		if entity.train.schedule then
			selected_item = parse_station_name(entity.train.schedule.records[1].station)
		else
			selected_item = nil
		end

		local main_window = player.gui.center.add{
			type = "frame",
			name = window_name,
			caption = { "entity-name.bwtc-item-train" },
			style = "bwtc_gui_main_window",
		}

		player.opened = main_window
		global_player.elements.item_train_gui = main_window
		global_player.entities.item_train_entity = entity.train

		local main_container = main_window.add{
			type = "frame",
			name = "main_container",
			direction = "vertical",
			style = "inside_shallow_frame",
		}
		local selected_item_container = main_container.add{
			type = "flow",
			name = "selected_item_container",
			direction = "horizontal",
			style = "bwtc_item_train_selected_item_container",
		}
		selected_item_container.add{
			type = "label",
			caption = { "bwtc.item-caption" },
		}
		local choose_item_button = selected_item_container.add{
			type = "choose-elem-button",
			name = choose_elem_button_name,
			elem_type = "item",
		}
		choose_item_button.elem_value = selected_item
		local station_header = main_container.add{
			type = "frame",
			name = "station_header",
			direction = "horizontal",
			style = "bwtc_item_train_station_header",
		}
		station_header.add{
			type = "label",
			caption = { "bwtc.stations-caption" },
			style = "bwtc_item_train_station_header_label",
		}
		local station_list_container = main_container.add{
			type = "frame",
			name = "station_list_container",
			direction = "vertical",
			style = "inside_shallow_frame_with_padding",
		}
		if entity.train.schedule then
			item_train.render_station_list(station_list_container, entity.train.schedule)
		else
			station_list_container.add{
				type = "label",
				caption = "None",
			}
		end
	end,

	toggle = function (player, entity)
		local global_player = global_player.get(player)
		local global_gui = global_player.elements.item_train_gui

		if global_gui == nil then
			item_train.new(player, global_player, entity)
		else
			global_gui.destroy()
			global_player.elements = {}
			global_player.entities = {}
		end
	end,

	clear = function (player)
		local global_player = global_player.get(player)

		if global_player.elements.item_train_gui ~= nil then
			item_train.toggle(player)
		end
	end,

	configure_train = function (player)
		local global_player = global_player.get(player)
		local global_gui = global_player.elements.item_train_gui
		local selected_item = global_gui.main_container.selected_item_container[choose_elem_button_name].elem_value
		local item = selected_item or "none"

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
					station = item .. " load",
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
					station = item .. " drop",
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

		item_train.render_station_list(global_gui.main_container.station_list_container, schedule)

		local train = global_player.entities.item_train_entity
		train.schedule = schedule
		train.manual_mode = false

		if train.locomotives["front_movers"][1].burner.inventory.is_empty() then
			train.locomotives["front_movers"][1].burner.inventory.insert("rocket-fuel")
		end
	end
}