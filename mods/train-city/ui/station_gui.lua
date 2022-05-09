require("ui.common")

local function parse_selection_and_direction(backer_name, item_type)
	selected_item = nil
	local words = {}

	for word in string.gmatch(backer_name, "%S+") do
		table.insert(words, word)
	end

	if item_type == "fluid" then
		selected_item = game.fluid_prototypes[words[1]] and words[1] or nil
	elseif item_type == "item" then
		selected_item = game.item_prototypes[words[1]] and words[1] or nil
	end

	local selected_direction = words[2] == "load" and "right" or "left"

	return selected_item, selected_direction
end

local function is_already_associated_with_an_item(backer_name, item_type)
	return parse_selection_and_direction(backer_name, item_type) ~= nil
end

local function find_all_trains_associated_with_station(station_name)
	local associated_trains = {}

	for _, train in pairs(game.surfaces[1].get_trains()) do
		if train.schedule then
			for _, record in pairs(train.schedule.records) do
				if record.station == station_name then
					table.insert(associated_trains, train)
				end
			end
		end
	end

	return associated_trains
end

local function build_fluid_circuit_condition(selected_fluid_name, selected_direction)
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

local function build_item_circuit_condition(selected_item_name, selected_direction)
	local item_prototype = game.item_prototypes[selected_item_name]

	if item_prototype == nil then
		return nil
	end

	local selected_item_stack_size = item_prototype.stack_size
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

local function build_circuit_condition(selected_item_name, item_type, selected_direction)
	if item_type == "fluid" then
		return build_fluid_circuit_condition(selected_item_name, selected_direction)
	else
		return build_item_circuit_condition(selected_item_name, selected_direction)
	end
end

local function set_new_train_station_configuration(train_station, selected_item_name, item_type, selected_direction)
	local control_behavior = train_station.get_or_create_control_behavior()
	control_behavior.enable_disable = true
	control_behavior.circuit_condition = build_circuit_condition(selected_item_name, item_type, selected_direction)

	train_station.backer_name = selected_item_name .. " " .. selected_direction
	train_station.trains_limit = 1
end

local function reassociate_trains_with_old_schedule(trains, schedule)
	for _, train in pairs(trains) do
		train.schedule = schedule
	end
end

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

station_gui = {}

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
