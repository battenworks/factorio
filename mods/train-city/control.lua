require("ui.item_trains_window")

local function initialize_global_player(player)
	global.bwtc_players[player.index] = { elements = {} }
end

script.on_init(
	function()
		global.bwtc_players = {}

		for _, player in pairs(game.players) do
			initialize_global_player(player)
		end
	end
)

script.on_configuration_changed(
	function(config_changed_data)
		if config_changed_data.mod_changes["train-city"] then
			for _, player in pairs(game.players) do
				item_trains_window.clear(player)
			end
		end
	end
)

script.on_event(defines.events.on_player_created,
	function(event)
		initialize_global_player(game.get_player(event.player_index))
	end
)

script.on_event(defines.events.on_player_removed,
	function(event)
		global.bwtc_players[event.player_index] = nil
	end
)

script.on_event("toggle_item_trains_window",
	function(event)
		item_trains_window.toggle(game.get_player(event.player_index))
	end
)

script.on_event(defines.events.on_gui_closed,
	function(event)
		if event.element and event.element.name == item_trains_window.name then
			item_trains_window.toggle(game.get_player(event.player_index))
		end
	end
)