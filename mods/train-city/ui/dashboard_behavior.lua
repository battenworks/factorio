dashboard_behavior = {}

local function get_configured_train_count(item_name)
	local train_count = 0
	local trains = game.surfaces[1].get_trains()

	for _, train in pairs(trains) do
		if train.schedule and train.schedule.records[1] then
			if train.schedule.records[1].station == item_name .. " load" then
				train_count = train_count + 1
			end
		end
	end

	return train_count
end

dashboard_behavior.build_item_view_models = function ()
	local item_view_models = {}

	for _, item in pairs(game.item_prototypes) do
		local load_stations = game.get_train_stops({ name = item.name .. " load" })
		local drop_stations = game.get_train_stops({ name = item.name .. " drop" })

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

dashboard_behavior.build_fluid_view_models = function ()
	local fluid_view_models = {}

	for _, fluid in pairs(game.fluid_prototypes) do
		local load_stations = game.get_train_stops({ name = fluid.name .. " load" })
		local drop_stations = game.get_train_stops({ name = fluid.name .. " drop" })

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

dashboard_behavior.build_potion_view_models = function (player)
	local player_position = player.position
	local player_surface = game.surfaces[1]
	local player_force = game.forces["player"]
	local current_logistic_network = player_surface.find_logistic_network_by_position(player_position, player_force)

	local potion_view_models = {}
	local potions = game.get_filtered_item_prototypes({
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
			item_count = current_logistic_network.get_item_count(potion.name)
		end

		local potion_view_model = {
			name = potion.name,
			count = item_count,
		}

		table.insert(potion_view_models, potion_view_model)
	end

	return potion_view_models
end

local function find_attached_chest(station, item_name)
	for _, circuit in pairs(station.circuit_connected_entities) do
		for _, chest in pairs(circuit) do
			if chest.name == item_name then
				return chest
			end
		end
	end
end

local function get_fuel_count(station)
	local fuel_count = "Unable to read fuel inventory"
	local chest = find_attached_chest(station, "logistic-chest-requester")

	if chest then
		fuel_count = chest.get_item_count("rocket-fuel")
	end

	return fuel_count
end

dashboard_behavior.build_fuel_station_view_models = function ()
	local fuel_station_view_models = {}
	local fuel_stations = game.get_train_stops({ name = "fuel" })

	for _, station in pairs(fuel_stations) do
		local fuel_station_view_model = {
			name = station.backer_name,
			count = get_fuel_count(station),
		}

		table.insert(fuel_station_view_models, fuel_station_view_model)
	end

	return fuel_station_view_models
end

local function get_ammo_count(station)
	local ammo_count = "Unable to read ammo inventory"
	local chest = find_attached_chest(station, "steel-chest")

	if chest then
		ammo_count = chest.get_item_count("uranium-rounds-magazine")
	end

	return ammo_count
end

dashboard_behavior.build_ammo_station_view_models = function ()
	local ammo_station_view_models = {}
	local ammo_stations = game.get_train_stops({ name = "ammo drop" })

	for _, station in pairs(ammo_stations) do
		local ammo_station_view_model = {
			name = station.backer_name,
			count = get_ammo_count(station),
		}

		table.insert(ammo_station_view_models, ammo_station_view_model)
	end

	return ammo_station_view_models
end
