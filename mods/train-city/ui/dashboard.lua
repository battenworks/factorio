require("ui.item_card")

local items = {"iron-ore", "copper-ore", "coal", "stone", "iron-plate" ,"copper-plate"}

local function get_global_player(player)
	return global.item_trains[player.index]
end

local name = "bwtc_dashboard"

dashboard = {
	name = name,

	new =	function (player, global_player, items)

		-- for i, proto in pairs(game.entity_prototypes) do
		-- 	log(i)
		-- end

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

		for _, item in pairs(items) do
			item_card.add_card_to_table(item, item_table)
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
		local global_player = get_global_player(player)
		local global_dashboard = global_player.elements.item_trains_dashboard

		if global_dashboard == nil then
			dashboard.new(player, global_player, items)
		else
			global_dashboard.destroy()
			global_player.elements = {}
		end
	end,

	clear = function (player)
		local global_player = get_global_player(player)

		if global_player.elements.item_trains_dashboard ~= nil then
			dashboard.toggle(player)
		end
	end
}