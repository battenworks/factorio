require("ui.common")
require("ui.item_card")
require("ui.potion_metrics_card")

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

local function build_potion_metrics(player)
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

dashboard = {
	name = name,
}

dashboard.new = function (player, global_player)
	local main_window = player.gui.screen.add{
		type = "frame",
		direction = "vertical",
	}
	main_window.auto_center = true
	main_window.name = name

	player.opened = main_window
	global_player.elements.train_city_dashboard = main_window

	local title_bar = main_window.add{
		type = "flow",
		direction = "horizontal",
	}
	title_bar.name = "header"
	title_bar.style.horizontally_stretchable = true

	local title = title_bar.add{
		type = "label",
		caption = { "bwtc.dashboard-caption" },
	}
	title.ignored_by_interaction = true
	title.style = "frame_title"

	local dragger = title_bar.add{
		type = "empty-widget"
	}
	dragger.name = "dragger"
	dragger.drag_target = main_window
	dragger.style = "draggable_space"
	dragger.style.height = 24
	dragger.style.width = 830

	local close_button = title_bar.add{ type = "sprite-button" }
	close_button.name = "close_button"
	close_button.clicked_sprite = "utility/close_black"
	close_button.hovered_sprite = "utility/close_black"
	close_button.sprite = "utility/close_white"
	close_button.style = "frame_action_button"
	close_button.tooltip = { "bwtc.close-button-caption" }
	-- actions = { on_click = { }},

	-- Main content frame
	local content_frame = main_window.add{
		type = "frame",
		name = "content_frame",
		direction = "vertical",
		style = "inside_deep_frame_for_tabs"
	}
	local tabbed_pane = content_frame.add{
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
	local potions_tab = tabbed_pane.add{
		type = "tab",
		caption = { "bwtc.potions-caption" },
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

	-- Science pack inventory content
	local potions_table = tabbed_pane.add{
		type = "table",
		column_count = 1,
	}
	for _, potion_metrics_model in pairs(build_potion_metrics(player)) do
		potion_metrics_card.add_card_to_table(potion_metrics_model, potions_table)
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
	tabbed_pane.add_tab(potions_tab, potions_table)
	tabbed_pane.add_tab(fuel_tab, fuel_label)
	tabbed_pane.add_tab(ammo_tab, ammo_label)
end

dashboard.toggle = function (player)
	local global_player = global_player.get(player)
	local global_dashboard = global_player.elements.train_city_dashboard

	if global_dashboard == nil then
		dashboard.new(player, global_player)
	else
		global_dashboard.destroy()
		global_player.elements = {}
	end
end

dashboard.clear = function (player)
	local global_player = global_player.get(player)

	if global_player.elements.train_city_dashboard ~= nil then
		dashboard.toggle(player)
	end
end
