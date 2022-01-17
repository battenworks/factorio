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

dashboard = {
	name = name,

	new =	function (player, global_player)
		local main_window = player.gui.center.add{
			type = "frame",
			name = name,
			caption = { "bwtc.item-trains-caption" },
			style = "bwtc_dashboard",
		}

		player.opened = main_window
		global_player.elements.item_trains_dashboard = main_window

		local tabbed_pane = main_window.add{
			type = "tabbed-pane",
		}
		local item_tab = tabbed_pane.add{
			type = "tab",
			caption = { "bwtc.items-caption" },
		}
		local item_scroll_pane = tabbed_pane.add{
			type = "scroll-pane",
			direction = "vertical",
		}
		local item_table = item_scroll_pane.add{
			type = "table",
			column_count = 4,
		}

		for _, card_model in pairs(build_item_card_models()) do
			item_card.add_card_to_table(card_model, item_table)
		end

		local fuel_tab = tabbed_pane.add{
			type = "tab",
			caption = { "bwtc.fuel-caption" },
		}
		local fuel_label = tabbed_pane.add{
			type = "label",
			caption = "Fuel stuff goes here",
		}
		local ammo_tab = tabbed_pane.add{
			type = "tab",
			caption = { "bwtc.ammo-caption" },
		}
		local ammo_label = tabbed_pane.add{
			type = "label",
			caption = "Ammo stuff goes here",
		}
		tabbed_pane.add_tab(item_tab, item_scroll_pane)
		tabbed_pane.add_tab(fuel_tab, fuel_label)
		tabbed_pane.add_tab(ammo_tab, ammo_label)
	end,

	toggle = function (player)
		local global_player = global_player.get(player)
		local global_dashboard = global_player.elements.item_trains_dashboard

		if global_dashboard == nil then
			dashboard.new(player, global_player)
		else
			global_dashboard.destroy()
			global_player.elements = {}
		end
	end,

	clear = function (player)
		local global_player = global_player.get(player)

		if global_player.elements.item_trains_dashboard ~= nil then
			dashboard.toggle(player)
		end
	end
}