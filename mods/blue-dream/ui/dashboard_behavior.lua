dashboard_behavior = {}

local function get_configured_train_count(item_name)
	local train_count = 0
	local trains = game.train_manager.get_trains({ name = item_name })

	for _, train in pairs(trains) do
		if train.schedule and train.schedule.records[1] then
			if train.schedule.records[1].station == item_name .. " load" then
				train_count = train_count + 1
			end
		end
	end

	return train_count
end

dashboard_behavior.build_item_view_models = function()
	local item_view_models = {}

	for _, item in pairs(prototypes.item) do
		local load_stations = game.train_manager.get_train_stops({ name = item.name .. " load" })
		local drop_stations = game.train_manager.get_train_stops({ name = item.name .. " drop" })

		if load_stations[1] or drop_stations[1] then
			local item_view_model = {
				item = item,
				item_type = "item",
				load_station_count = #load_stations,
				drop_station_count = #drop_stations,
				configured_train_count = get_configured_train_count(item.name),
				fueling_count = 666,
			}

			table.insert(item_view_models, item_view_model)
		end
	end

	return item_view_models
end

dashboard_behavior.build_fluid_view_models = function()
	local fluid_view_models = {}

	for _, fluid in pairs(prototypes.fluid) do
		local load_stations = game.train_manager.get_train_stops({ name = fluid.name .. " load" })
		local drop_stations = game.train_manager.get_train_stops({ name = fluid.name .. " drop" })

		if load_stations[1] or drop_stations[1] then
			local fluid_view_model = {
				item = fluid,
				item_type = "fluid",
				load_station_count = #load_stations,
				drop_station_count = #drop_stations,
				configured_train_count = get_configured_train_count(fluid.name),
				fueling_count = 666,
			}

			table.insert(fluid_view_models, fluid_view_model)
		end
	end

	return fluid_view_models
end

dashboard_behavior.build_potion_view_models = function(player)
	local player_position = player.position
	local player_surface = game.surfaces[1]
	local player_force = game.forces["player"]
	local current_logistic_network = player_surface.find_logistic_network_by_position(player_position, player_force)

	local potion_view_models = {}
	local potions = prototypes.get_item_filtered({
		{
			filter = "subgroup",
			subgroup = "science-pack",
			mode = "and"
		},
		{
			filter = "type",
			type = "tool",
			mode = "and"
		}
	})

	for _, potion in pairs(potions) do
		local item_count = "player not in logistics network"

		if current_logistic_network ~= nil then
			item_count = tostring(current_logistic_network.get_item_count(potion.name))
		end

		local potion_view_model = {
			name = potion.name,
			count = item_count,
		}

		table.insert(potion_view_models, potion_view_model)
	end

	return potion_view_models
end

local function get_item_count(station, item_name)
	local item_count = "Unable to read station inventory"
	
	local green_signals = station.get_signals(defines.wire_connector_id.circuit_green)
	if green_signals then
		for _, signal in pairs(green_signals) do
			if signal.signal.name == item_name then
				item_count = signal.count
			end
		end
	end

	local red_signals = station.get_signals(defines.wire_connector_id.circuit_red)
	if red_signals then
		for _, signal in pairs(red_signals) do
			if signal.signal.name == item_name then
				item_count = signal.count
			end
		end
	end

	return item_count
end

dashboard_behavior.build_fuel_station_view_models = function()
	local fuel_station_view_models = {}
	
	for _, force in pairs(game.forces) do
		local nauvis_stations = game.train_manager.get_train_stops({ force = force, surface = "nauvis" })
		
		for _, nauvis_station in pairs(nauvis_stations) do
			if nauvis_station.valid and nauvis_station.backer_name == "fuel" then
				local fuel_station_view_model = {
					name = nauvis_station.backer_name,
					count = get_item_count(nauvis_station, "rocket-fuel"),
				}
				
				table.insert(fuel_station_view_models, fuel_station_view_model)
			end
		end
	end
	
	return fuel_station_view_models
end

dashboard_behavior.build_ammo_station_view_models = function()
	local ammo_station_view_models = {}
	
	for _, force in pairs(game.forces) do
		local nauvis_stations = game.train_manager.get_train_stops({ force = force, surface = "nauvis" })
		
		for _, nauvis_station in pairs(nauvis_stations) do
			if nauvis_station.valid and nauvis_station.backer_name == "ammo drop" then
				local ammo_station_view_model = {
					name = nauvis_station.backer_name,
					count = get_item_count(nauvis_station, "uranium-rounds-magazine"),
				}
				
				table.insert(ammo_station_view_models, ammo_station_view_model)
			end
		end
	end
	 
	return ammo_station_view_models
end
