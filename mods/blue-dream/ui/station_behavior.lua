require("ui.station_model")

station_behavior = {}

station_behavior.parse_selection_and_direction = function(backer_name, item_type)
	selected_item = nil
	local words = {}

	for word in string.gmatch(backer_name, "%S+") do
		table.insert(words, word)
	end

	if item_type == "fluid" then
		selected_item = prototypes.fluid[words[1]] and words[1] or nil
	elseif item_type == "item" then
		selected_item = prototypes.item[words[1]] and words[1] or nil
	end

	local selected_direction = words[2] == "load" and "right" or "left"

	return selected_item, selected_direction
end

station_behavior.is_already_associated_with_an_item = function(backer_name, item_type)
	return station_behavior.parse_selection_and_direction(backer_name, item_type) ~= nil
end

station_behavior.find_all_trains_associated_with_station = function(station_name)
	local associated_trains = {}

	for _, train in pairs(game.train_manager.get_trains({ surface = game.surfaces[1] })) do
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

station_behavior.set_new_train_station_configuration = function(train_station, selected_item_name, item_type, selected_direction)
	train_station.backer_name = selected_item_name .. " " .. selected_direction
	train_station.trains_limit = 0
end

station_behavior.reassociate_trains_with_old_schedule = function(trains, schedule)
	for _, train in pairs(trains) do
		train.schedule = schedule
	end
end

station_behavior.evaluate_station_availability = function(station)
	if station.name ~= "bwbd-item-station" and station.name ~= "bwbd-fluid-station" then
		return
	end

	local station_model = station_model.new(station)

	if station_model.load_direction == "load" then
		if station_can_supply_train_load(station_model) then
			station.trains_limit = 1
		else
			station.trains_limit = 0
		end
	elseif station_model.load_direction == "drop" then
		if station_can_accept_train_load(station_model) then
			station.trains_limit = 1
		else
			station.trains_limit = 0
		end
	end
end

function station_can_supply_train_load(station_model)
	return station_model.inventory > station_model.train_capacity
end

function station_can_accept_train_load(station_model)
	return station_model.capacity - station_model.inventory > station_model.train_capacity
end
