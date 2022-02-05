require("ui.common")
require("ui.item_card")

local name = "bwtc_dashboard"

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

local function build_item_card_models()
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

local function build_fluid_card_models()
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

dashboard = {
	name = name,

	new = function (player, global_player)
		local main_window = player.gui.center.add{
			type = "frame",
			name = name,
			caption = { "bwtc.dashboard-caption" },
		}

		player.opened = main_window
		global_player.elements.train_city_dashboard = main_window

		local main_container = main_window.add{
			type = "frame",
			name = "main_container",
			direction = "vertical",
			style = "inside_shallow_frame",
		}
		local tabbed_pane = main_container.add{
			type = "tabbed-pane",
			style = "bwtc_tabbed_pane",
		}
		local items_tab = tabbed_pane.add{
			type = "tab",
			caption = { "bwtc.items-caption" },
		}
		local fluids_tab = tabbed_pane.add{
			type = "tab",
			caption = { "bwtc.fluids-caption" },
		}
		local fuel_tab = tabbed_pane.add{
			type = "tab",
			caption = { "bwtc.fuel-caption" },
		}
		local ammo_tab = tabbed_pane.add{
			type = "tab",
			caption = { "bwtc.ammo-caption" },
		}

		-- Items content
		local items_scroll_pane = tabbed_pane.add{
			type = "scroll-pane",
			direction = "vertical",
		}
		local items_table = items_scroll_pane.add{
			type = "table",
			column_count = 4,
		}
		for _, card_model in pairs(build_item_card_models()) do
			item_card.add_card_to_table(card_model, items_table)
		end

		-- Fluids content
		local fluids_scroll_pane = tabbed_pane.add{
			type = "scroll-pane",
			direction = "vertical",
		}
		local fluids_table = fluids_scroll_pane.add{
			type = "table",
			column_count = 4,
		}
		for _, card_model in pairs(build_fluid_card_models()) do
			item_card.add_card_to_table(card_model, fluids_table)
		end

		-- Fuel content
		local fuel_label = tabbed_pane.add{
			type = "label",
			caption = "Fuel stuff goes here",
		}

		-- Ammo content
		local ammo_label = tabbed_pane.add{
			type = "label",
			caption = "Ammo stuff goes here",
		}

		tabbed_pane.add_tab(items_tab, items_scroll_pane)
		tabbed_pane.add_tab(fluids_tab, fluids_scroll_pane)
		tabbed_pane.add_tab(fuel_tab, fuel_label)
		tabbed_pane.add_tab(ammo_tab, ammo_label)
	end,

	toggle = function (player)
		local global_player = global_player.get(player)
		local global_dashboard = global_player.elements.train_city_dashboard

		if global_dashboard == nil then
			dashboard.new(player, global_player)
		else
			global_dashboard.destroy()
			global_player.elements = {}
		end
	end,

	clear = function (player)
		local global_player = global_player.get(player)

		if global_player.elements.train_city_dashboard ~= nil then
			dashboard.toggle(player)
		end
	end
}
