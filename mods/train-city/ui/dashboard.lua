require("ui.common")
require("ui.dashboard_behavior")
require("ui.item_card")
require("ui.potion_metrics_card")

local gui_name = "bwtc_dashboard"

dashboard = {
	name = gui_name,
}

local function new(player, global_player)
	local main_window = player.gui.screen.add{ type = "frame", direction = "vertical" }
	main_window.name = gui_name
	main_window.auto_center = true

	player.opened = main_window
	global_player.elements.train_city_dashboard = main_window

	local title_bar_caption = { "bwtc.dashboard-caption" }
	common.add_title_bar_to_gui(title_bar_caption, main_window)

	local content_frame = main_window.add{ type = "frame", direction = "vertical" }
	content_frame.name = "content_frame"
	content_frame.style = "inside_deep_frame_for_tabs"

	local tabbed_pane = content_frame.add{ type = "tabbed-pane" }
	tabbed_pane.style = "bwtc_tabbed_pane"

	local items_tab = tabbed_pane.add{ type = "tab" }
	items_tab.caption = { "bwtc.items-caption" }

	local fluids_tab = tabbed_pane.add{ type = "tab" }
	fluids_tab.caption = { "bwtc.fluids-caption" }

	local fuel_tab = tabbed_pane.add{ type = "tab" }
	fuel_tab.caption = { "bwtc.fuel-caption" }

	local ammo_tab = tabbed_pane.add{ type = "tab" }
	ammo_tab.caption = { "bwtc.ammo-caption" }

	local potions_tab = tabbed_pane.add{ type = "tab" }
	potions_tab.caption = { "bwtc.potions-caption" }

	local items_scroll_pane = tabbed_pane.add{ type = "scroll-pane", direction = "vertical" }
	local items_table = items_scroll_pane.add{ type = "table", column_count = 4 }
	for _, card_model in pairs(dashboard_behavior.build_item_card_models()) do
		item_card.add_card_to_table(card_model, items_table)
	end

	local fluids_scroll_pane = tabbed_pane.add{ type = "scroll-pane", direction = "vertical" }
	local fluids_table = fluids_scroll_pane.add{ type = "table", column_count = 4 }
	for _, card_model in pairs(dashboard_behavior.build_fluid_card_models()) do
		item_card.add_card_to_table(card_model, fluids_table)
	end

	local potions_table = tabbed_pane.add{ type = "table", column_count = 1 }
	for _, potion_metrics_model in pairs(dashboard_behavior.build_potion_metrics(player)) do
		potion_metrics_card.add_card_to_table(potion_metrics_model, potions_table)
	end

	local fuel_label = tabbed_pane.add{ type = "label" }
	fuel_label.caption = "Fuel stuff goes here"

	local ammo_label = tabbed_pane.add{ type = "label" }
	ammo_label.caption = "Ammo stuff goes here"

	tabbed_pane.add_tab(items_tab, items_scroll_pane)
	tabbed_pane.add_tab(fluids_tab, fluids_scroll_pane)
	tabbed_pane.add_tab(potions_tab, potions_table)
	tabbed_pane.add_tab(fuel_tab, fuel_label)
	tabbed_pane.add_tab(ammo_tab, ammo_label)
end

dashboard.toggle = function (player)
	local global_player = common.get_global_player(player)
	local global_dashboard = global_player.elements.train_city_dashboard

	if global_dashboard == nil then
		new(player, global_player)
	else
		global_dashboard.destroy()
		global_player.elements = {}
	end
end

dashboard.clear = function (player)
	local global_player = common.get_global_player(player)

	if global_player.elements.train_city_dashboard ~= nil then
		dashboard.toggle(player)
	end
end
