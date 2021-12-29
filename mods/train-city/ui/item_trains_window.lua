require("ui.item_card")

local items = {"iron-ore", "copper-ore", "coal", "stone", "iron-plate" ,"copper-plate"}

local function get_global_player(player)
	return global.bwtc_players[player.index]
end

local name = "bwtc_main_window"

item_trains_window = {
	name = name,

	new =	function(player, global_player, items)
		local screen_element = player.gui.screen
		local main_window = screen_element.add{
			type = "frame",
			name = name,
			caption = { "bwtc.main-window-caption" },
		}
		main_window.style.size = { 950, 600 }
		main_window.auto_center = true

		player.opened = main_window
		global_player.elements.main_item_trains_window = main_window

		local tabbed_pane = main_window.add{
			type = "tabbed-pane",
		}
		local item_tab = tabbed_pane.add{
			type = "tab",
			caption = { "bwtc.item-tab-caption" },
		}
		local item_scroll_pane = tabbed_pane.add{
			type = "scroll-pane",
			direction = "vertical",
		}
		local item_table = item_scroll_pane.add{
			type = "table",
			column_count = 4,
		}

		for _, item in pairs(items) do
			item_card.add_card_to_table(item, item_table)
		end

		local fuel_tab = tabbed_pane.add{
			type = "tab",
			caption = { "bwtc.fuel-tab-caption" },
		}
		local fuel_label = tabbed_pane.add{
			type = "label",
			caption = "Fuel stuff goes here",
		}
		local ammo_tab = tabbed_pane.add{
			type = "tab",
			caption = { "bwtc.ammo-tab-caption" },
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
		local global_player = get_global_player(player)
		local main_frame_foo = global_player.elements.main_item_trains_window

		if main_frame_foo == nil then
			item_trains_window.new(player, global_player, items)
		else
			main_frame_foo.destroy()
			global_player.elements = {}
		end
	end,

	clear = function(player)
		local global_player = get_global_player(player)

		if global_player.elements.main_item_trains_window ~= nil then
			item_trains_window.toggle(player)
		end
	end
}