require("ui.item_trains_window")
require("ui.item_train_station")

local function initialize_global_player(player)
	global.item_trains[player.index] = { elements = {}, entities = {} }
end

script.on_init(
	function ()
		global.item_trains = {}

		for _, player in pairs(game.players) do
			initialize_global_player(player)
		end
	end
)

script.on_configuration_changed(
	function (config_changed_data)
		if config_changed_data.mod_changes["train-city"] then
			for _, player in pairs(game.players) do
				item_trains_window.clear(player)
			end
		end
	end
)

script.on_event(defines.events.on_player_created,
	function (event)
		initialize_global_player(game.get_player(event.player_index))
	end
)

script.on_event(defines.events.on_player_removed,
	function (event)
		global.item_trains[event.player_index] = nil
	end
)

script.on_event("toggle_item_trains_window",
	function (event)
		item_trains_window.toggle(game.get_player(event.player_index))
	end
)

script.on_event(defines.events.on_gui_opened,
	function (event)
		local player = game.get_player(event.player_index)
		
		if event.gui_type == defines.gui_type.entity and event.entity.name == "bwtc-item-train-station" then
			item_train_station.toggle(player, event.entity)
		end
	end
)

script.on_event(defines.events.on_gui_closed,
	function (event)
		local player = game.get_player(event.player_index)
		
		if event.element and event.element.name == item_trains_window.name then
			item_trains_window.toggle(player)
		elseif event.element and event.element.name == item_train_station.name then
			item_train_station.toggle(player)
		end
	end
)

script.on_event(defines.events.on_gui_elem_changed,
	function (event)
		local player = game.get_player(event.player_index)

		if event.element and event.element.name == item_train_station.selected_item_control then
			item_train_station.configure_train_station(player)
		end
	end
)

script.on_event(defines.events.on_gui_switch_state_changed,
	function (event)
		local player = game.get_player(event.player_index)

		if event.element and event.element.name == item_train_station.selected_direction_control then
			item_train_station.configure_train_station(player)
		end
	end
)