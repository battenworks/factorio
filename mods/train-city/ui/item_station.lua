require("ui.common")

local window_name = "bwtc_item_station_gui"
local choose_elem_button_name = "bwtc_item_station_selected_item"
local direction_switch_name = "bwtc_item_station_direction_switch"

local function parse_station_backer_name(backer_name)
	local words = {}

	for word in string.gmatch(backer_name, "%S+") do
		table.insert(words, word)
	end

	local selected_item = game.item_prototypes[words[1]] and words[1] or nil
	local selected_direction = words[2] == "load" and "right" or "left"

	return selected_item, selected_direction
end

local function find_all_trains_associated_with_item(item)
	local associated_trains = {}

	for _, train in pairs(game.surfaces[1].get_trains()) do
		if train.schedule and train.schedule.records[1].station == item .. " load" then
			table.insert(associated_trains, train)
		end
	end

	return associated_trains
end

local function build_circuit_condition(selected_item_name, selected_direction)
	local selected_item_stack_size = game.item_prototypes[selected_item_name].stack_size
	local cargo_train_capacity = selected_item_stack_size * 80
	local condition_comparator
	local condition_constant

	if selected_direction == "load" then
		condition_comparator = ">"
		condition_constant = cargo_train_capacity
	else
		condition_comparator = "<"
		local total_capacity = selected_item_stack_size * 48 * 12
		condition_constant = total_capacity - cargo_train_capacity
	end

	return {
		condition = {
			comparator = condition_comparator,
			first_signal = {
				type = "item",
				name = selected_item_name,
			},
			constant = condition_constant,
		}
	}
end

local function set_new_train_station_configuration(train_station, selected_item_name, selected_direction)
	local control_behavior = train_station.get_or_create_control_behavior()
	control_behavior.enable_disable = true
	control_behavior.circuit_condition = build_circuit_condition(selected_item_name, selected_direction)

	train_station.backer_name = selected_item_name .. " " .. selected_direction
	train_station.trains_limit = 1
end

local function reassociate_trains_with_old_schedule(trains, schedule)
	for _, train in pairs(trains) do
		train.schedule = schedule
	end
end

item_station = {
	name = window_name,
	selected_item_control = choose_elem_button_name,
	selected_direction_control = direction_switch_name,

	new = function (player, global_player, entity)
		local selected_item, selected_direction = parse_station_backer_name(entity.backer_name)

		local main_window = player.gui.center.add{
			type = "frame",
			name = window_name,
			caption = { "entity-name.bwtc-item-station" },
			style = "bwtc_gui_main_window",
		}

		player.opened = main_window
		global_player.elements.item_station_gui = main_window
		global_player.entities.item_station_entity = entity

		local main_container = main_window.add{
			type = "frame",
			name = "main_container",
			direction = "vertical",
			style = "inside_shallow_frame_with_padding",
		}
		local selected_item_container = main_container.add{
			type = "flow",
			name = "selected_item_container",
			direction = "horizontal",
			style = "bwtc_item_station_selected_item_container",
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
		local selected_direction_container = main_container.add{
			type = "flow",
			name = "selected_direction_container",
			direction = "horizontal",
			style = "bwtc_item_station_selected_direction_container",
		}
		selected_direction_container.add{
			type = "label",
			caption = { "bwtc.drop-caption" },
		}
		selected_direction_container.add{
			type = "switch",
			name = direction_switch_name,
			switch_state = selected_direction,
		}
		selected_direction_container.add{
			type = "label",
			caption = { "bwtc.load-caption" },
		}

	end,

	toggle = function (player, entity)
		local global_player = global_player.get(player)
		local global_gui = global_player.elements.item_station_gui

		if global_gui == nil then
			item_station.new(player, global_player, entity)
		else
			global_gui.destroy()
			global_player.elements = {}
			global_player.entities = {}
		end
	end,

	clear = function (player)
		local global_player = global_player.get(player)

		if global_player.elements.item_station_gui ~= nil then
			item_station.toggle(player)
		end
	end,

	configure_train_station = function (player)
		local global_player = global_player.get(player)
		local global_gui = global_player.elements.item_station_gui
		local train_station = global_player.entities.item_station_entity
		local old_item = parse_station_backer_name(train_station.backer_name)
		local selected_item_name = global_gui.main_container.selected_item_container[choose_elem_button_name].elem_value or "none"
		local switch_direction = global_gui.main_container.selected_direction_container[direction_switch_name].switch_state
		local selected_direction = switch_direction == "left" and "drop" or "load"

		if old_item then
			local associated_trains = find_all_trains_associated_with_item(old_item)

			if #associated_trains > 0 then
				old_schedule = associated_trains[1].schedule
			end

			set_new_train_station_configuration(train_station, selected_item_name, selected_direction)
			reassociate_trains_with_old_schedule(associated_trains, old_schedule)
		else
			set_new_train_station_configuration(train_station, selected_item_name, selected_direction)
		end
	end
}