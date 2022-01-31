require("ui.dashboard")
require("ui.fluid_station")
require("ui.fluid_train")
require("ui.item_station")
require("ui.item_train")

local function initialize_global_player(player)
	global.train_city[player.index] = { elements = {}, entities = {} }
end

script.on_init(
	function ()
		global.train_city = {}

		for _, player in pairs(game.players) do
			initialize_global_player(player)
		end
	end
)

script.on_configuration_changed(
	function (config_changed_data)
		if config_changed_data.mod_changes["train-city"] then
			for _, player in pairs(game.players) do
				dashboard.clear(player)
				fluid_station.clear(player)
				fluid_train.clear(player)
				item_station.clear(player)
				item_train.clear(player)
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
		global.train_city[event.player_index] = nil
	end
)

script.on_event("toggle_dashboard",
	function (event)
		dashboard.toggle(game.get_player(event.player_index))
	end
)

script.on_event(defines.events.on_gui_opened,
	function (event)
		local player = game.get_player(event.player_index)

		if event.gui_type == defines.gui_type.entity and event.entity then
			if event.entity.name == "bwtc-fluid-station" then
				fluid_station.toggle(player, event.entity)
			elseif event.entity.name == "bwtc-fluid-train" then
				fluid_train.toggle(player, event.entity)
			elseif event.entity.name == "bwtc-item-station" then
				item_station.toggle(player, event.entity)
			elseif event.entity.name == "bwtc-item-train" then
				item_train.toggle(player, event.entity)
			end
		end
	end
)

script.on_event(defines.events.on_gui_closed,
	function (event)
		local player = game.get_player(event.player_index)

		if event.element then
			if event.element.name == dashboard.name then
				dashboard.toggle(player)
			elseif event.element.name == fluid_station.name then
				fluid_station.toggle(player)
			elseif event.element.name == fluid_train.name then
				fluid_train.toggle(player)
			elseif event.element.name == item_station.name then
				item_station.toggle(player)
			elseif event.element.name == item_train.name then
				item_train.toggle(player)
			end
		end
	end
)

script.on_event(defines.events.on_gui_elem_changed,
	function (event)
		local player = game.get_player(event.player_index)

		if event.element then
			if event.element.name == fluid_station.selected_fluid_control then
				fluid_station.configure_train_station(player)
			elseif event.element.name == fluid_train.selection_button_name then
				fluid_train.configure_train(player)
			elseif event.element.name == item_station.selected_item_control then
				item_station.configure_train_station(player)
			elseif event.element.name == item_train.selection_button_name then
				item_train.configure_train(player)
			end
		end
	end
)

script.on_event(defines.events.on_gui_switch_state_changed,
	function (event)
		local player = game.get_player(event.player_index)

		if event.element and event.element.name == item_station.selected_direction_control then
			item_station.configure_train_station(player)
		elseif event.element and event.element.name == fluid_station.selected_direction_control then
			fluid_station.configure_train_station(player)
		end
	end
)
