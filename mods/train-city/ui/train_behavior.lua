train_behavior = {}

train_behavior.parse_selected_item = function(schedule, item_type)
	selected_item = nil

	if schedule then
		local station_name = schedule.records[1].station
		local words = {}

		for word in string.gmatch(station_name, "%S+") do
			table.insert(words, word)
		end

		if item_type == "fluid" then
			selected_item = game.fluid_prototypes[words[1]] and words[1] or nil
		elseif item_type == "item" then
			selected_item = game.item_prototypes[words[1]] and words[1] or nil
		end
	end

	return selected_item
end

train_behavior.render_station_list = function(container, schedule)
	container.clear()
	local station_list = container.add {
		type = "table",
		column_count = 1,
	}
	for _, record in pairs(schedule.records) do
		station_list.add {
			type = "label",
			caption = record.station,
			style = "bwtc_train_station_line_item",
		}
	end
end

local function find_next_rail(train)
	local current_rail = train.schedule.records[1].rail
	local direction = train.locomotives.front_movers[1].direction

	if direction == defines.direction.north then
	elseif direction == defines.direction.south then
	elseif direction == defines.direction.east then
	elseif direction == defines.direction.west then
	end

	return train.schedule.records[1].rail
end

train_behavior.evaluate_transportation_train_command = function(train)
	if not next(train.passengers) then
		-- add a rail record and wait condition before the original record
		if train.schedule and train.schedule.records and train.schedule.records[1].wait_conditions then
			if train.schedule.records[1].rail ~= train.front_rail then
				local destination = find_next_rail(train)
				local new_schedule = {
					current = 1,
					records = {
						{
							rail = train.front_rail,
							temporary = true,
							wait_conditions = {
								{
									type = "passenger_present",
									compare_type = "or"
								}
							}
						},
						{
							rail = destination,
							temporary = true
						}
					}
				}

				train.schedule = new_schedule
			end
		end
	else
		game.players[1].print("GO")
	end
end
