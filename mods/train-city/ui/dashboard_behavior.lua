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

dashboard_behavior.build_item_card_models = function ()
	local item_cards = {}

	for _, item in pairs(game.item_prototypes) do
		local load_stations = game.get_train_stops({ name = item.name .. " load" })
		local drop_stations = game.get_train_stops({ name = item.name .. " drop" })

		if load_stations[1] or drop_stations[1] then
			local item_card = {
				item = item,
				item_type = "item",
				load_station_count = #load_stations,
				drop_station_count = #drop_stations,
				configured_train_count = get_configured_train_count(item.name),
				fueling_count = 666,
			}

			table.insert(item_cards, item_card)
		end
	end

	return item_cards
end

dashboard_behavior.build_fluid_card_models = function ()
	local fluid_cards = {}

	for _, fluid in pairs(game.fluid_prototypes) do
		local load_stations = game.get_train_stops({ name = fluid.name .. " load" })
		local drop_stations = game.get_train_stops({ name = fluid.name .. " drop" })

		if load_stations[1] or drop_stations[1] then
			local fluid_card = {
				item = fluid,
				item_type = "fluid",
				load_station_count = #load_stations,
				drop_station_count = #drop_stations,
				configured_train_count = get_configured_train_count(fluid.name),
				fueling_count = 666,
			}

			table.insert(fluid_cards, fluid_card)
		end
	end

	return fluid_cards
end

dashboard_behavior.build_potion_metrics = function (player)
	local player_position = player.position
	local player_surface = game.surfaces[1]
	local player_force = game.forces["player"]
	local current_logistic_network = player_surface.find_logistic_network_by_position(player_position, player_force)

	local potion_metrics = {}
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

		local potion_metric = {
			name = potion.name,
			count = item_count,
		}

		table.insert(potion_metrics, potion_metric)
	end

	return potion_metrics
end
