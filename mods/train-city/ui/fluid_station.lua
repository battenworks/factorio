require("ui.common")

local window_name = "bwtc_fluid_station_gui"
local choose_elem_button_name = "bwtc_fluid_station_selected_fluid"
local direction_switch_name = "bwtc_fluid_station_direction_switch"

local function parse_station_backer_name(backer_name)
	local words = {}

	for word in string.gmatch(backer_name, "%S+") do
		table.insert(words, word)
	end

	local selected_fluid = game.fluid_prototypes[words[1]] and words[1] or nil
	local selected_direction = words[2] == "load" and "right" or "left"

	return selected_fluid, selected_direction
end

local function find_all_trains_associated_with_fluid(fluid)
	local associated_trains = {}

	for _, train in pairs(game.surfaces[1].get_trains()) do
		if train.schedule and train.schedule.records[1].station == fluid .. " load" then
			table.insert(associated_trains, train)
		end
	end

	return associated_trains
end

local function build_circuit_condition(selected_fluid_name, selected_direction)
	local fluid_prototype = game.fluid_prototypes[selected_fluid_name]

	if fluid_prototype == nil then
		return nil
	end

	local cargo_train_capacity = 50000
	local condition_comparator
	local condition_constant

	if selected_direction == "load" then
		condition_comparator = ">"
		condition_constant = cargo_train_capacity
	else
		condition_comparator = "<"
		local total_capacity = 150000
		condition_constant = total_capacity - cargo_train_capacity
	end

	return {
		condition = {
			comparator = condition_comparator,
			first_signal = {
				type = "fluid",
				name = selected_fluid_name,
			},
			constant = condition_constant,
		}
	}
end

local function set_new_train_station_configuration(train_station, selected_fluid_name, selected_direction)
	local control_behavior = train_station.get_or_create_control_behavior()
	control_behavior.enable_disable = true
	control_behavior.circuit_condition = build_circuit_condition(selected_fluid_name, selected_direction)

	train_station.backer_name = selected_fluid_name .. " " .. selected_direction
	train_station.trains_limit = 1
end

local function reassociate_trains_with_old_schedule(trains, schedule)
	for _, train in pairs(trains) do
		train.schedule = schedule
	end
end

fluid_station = {
	name = window_name,
	selected_fluid_control = choose_elem_button_name,
	selected_direction_control = direction_switch_name,

	new = function (player, global_player, entity)
		local selected_fluid, selected_direction = parse_station_backer_name(entity.backer_name)

		local main_window = player.gui.center.add{
			type = "frame",
			name = window_name,
			caption = { "entity-name.bwtc-fluid-station" },
			style = "bwtc_gui_main_window",
		}

		player.opened = main_window
		global_player.elements.fluid_station_gui = main_window
		global_player.entities.fluid_station_entity = entity

		local main_container = main_window.add{
			type = "frame",
			name = "main_container",
			direction = "vertical",
			style = "inside_shallow_frame_with_padding",
		}
		local selected_fluid_container = main_container.add{
			type = "flow",
			name = "selected_fluid_container",
			direction = "horizontal",
			style = "bwtc_station_selection_container",
		}
		selected_fluid_container.add{
			type = "label",
			caption = { "bwtc.fluid-caption" },
		}
		local choose_fluid_button = selected_fluid_container.add{
			type = "choose-elem-button",
			name = choose_elem_button_name,
			elem_type = "fluid",
		}
		choose_fluid_button.elem_value = selected_fluid
		local selected_direction_container = main_container.add{
			type = "flow",
			name = "selected_direction_container",
			direction = "horizontal",
			style = "bwtc_station_selected_direction_container",
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
		local global_gui = global_player.elements.fluid_station_gui

		if global_gui == nil then
			fluid_station.new(player, global_player, entity)
		else
			global_gui.destroy()
			global_player.elements = {}
			global_player.entities = {}
		end
	end,

	clear = function (player)
		local global_player = global_player.get(player)

		if global_player.elements.fluid_station_gui ~= nil then
			fluid_station.toggle(player)
		end
	end,

	configure_train_station = function (player)
		local global_player = global_player.get(player)
		local global_gui = global_player.elements.fluid_station_gui
		local train_station = global_player.entities.fluid_station_entity
		local old_fluid = parse_station_backer_name(train_station.backer_name)
		local selected_fluid_name = global_gui.main_container.selected_fluid_container[choose_elem_button_name].elem_value or "none"
		local switch_direction = global_gui.main_container.selected_direction_container[direction_switch_name].switch_state
		local selected_direction = switch_direction == "left" and "drop" or "load"

		if old_fluid then
			local associated_trains = find_all_trains_associated_with_fluid(old_fluid)

			if #associated_trains > 0 then
				old_schedule = associated_trains[1].schedule
			end

			set_new_train_station_configuration(train_station, selected_fluid_name, selected_direction)
			reassociate_trains_with_old_schedule(associated_trains, old_schedule)
		else
			set_new_train_station_configuration(train_station, selected_fluid_name, selected_direction)
		end
	end
}
