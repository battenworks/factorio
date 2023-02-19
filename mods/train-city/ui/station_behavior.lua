station_behavior = {}

station_behavior.parse_selection_and_direction = function(backer_name, item_type)
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

station_behavior.is_already_associated_with_an_item = function(backer_name, item_type)
	return station_behavior.parse_selection_and_direction(backer_name, item_type) ~= nil
end

station_behavior.find_all_trains_associated_with_station = function(station_name)
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

station_behavior.set_new_train_station_configuration = function(train_station, selected_item_name, item_type, selected_direction)
	local control_behavior = train_station.get_or_create_control_behavior()
	control_behavior.enable_disable = true
	control_behavior.circuit_condition = build_circuit_condition(selected_item_name, item_type, selected_direction)

	train_station.backer_name = selected_item_name .. " " .. selected_direction
	train_station.trains_limit = 1
end

station_behavior.reassociate_trains_with_old_schedule = function(trains, schedule)
	for _, train in pairs(trains) do
		train.schedule = schedule
	end
end
