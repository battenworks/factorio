require("ui.dashboard")
require("ui.fluid_station_view")
require("ui.fluid_train_view")
require("ui.item_station_view")
require("ui.item_train_view")

local function initialize_global_player(player)
	global.train_city[player.index] = { elements = {}, entities = {} }
end

script.on_init(
	function()
		global.train_city = {}

		for _, player in pairs(game.players) do
			initialize_global_player(player)
		end
	end
)

script.on_configuration_changed(
	function(config_changed_data)
		if config_changed_data.mod_changes["train-city"] then
			for _, player in pairs(game.players) do
				dashboard.clear(player)
				fluid_station_view.clear(player)
				fluid_train_view.clear(player)
				item_station_view.clear(player)
				item_train_view.clear(player)
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
		global.train_city[event.player_index] = nil
	end
)

script.on_event("toggle_dashboard",
	function(event)
		dashboard.toggle(game.get_player(event.player_index))
	end
)

script.on_event(defines.events.on_gui_opened,
	function(event)
		local player = game.get_player(event.player_index)

		if event.gui_type == defines.gui_type.entity and event.entity then
			if event.entity.name == "bwtc-fluid-station" then
				fluid_station_view.toggle(player, event.entity)
			elseif event.entity.name == "bwtc-fluid-train" then
				fluid_train_view.toggle(player, event.entity)
			elseif event.entity.name == "bwtc-item-station" then
				item_station_view.toggle(player, event.entity)
			elseif event.entity.name == "bwtc-item-train" then
				item_train_view.toggle(player, event.entity)
			end
		end
	end
)

script.on_event(defines.events.on_gui_closed,
	function(event)
		local player = game.get_player(event.player_index)

		if event.element then
			if event.element.name == dashboard.name then
				dashboard.toggle(player)
			elseif event.element.name == fluid_station_view.name then
				fluid_station_view.toggle(player)
			elseif event.element.name == fluid_train_view.name then
				fluid_train_view.toggle(player)
			elseif event.element.name == item_station_view.name then
				item_station_view.toggle(player)
			elseif event.element.name == item_train_view.name then
				item_train_view.toggle(player)
			end
		end
	end
)

script.on_event(defines.events.on_gui_elem_changed,
	function(event)
		local player = game.get_player(event.player_index)

		if event.element then
			if event.element.name == fluid_station_view.selection_button_name then
				fluid_station_view.configure_train_station(player)
			elseif event.element.name == fluid_train_view.selection_button_name then
				fluid_train_view.configure_train(player)
			elseif event.element.name == item_station_view.selection_button_name then
				item_station_view.configure_train_station(player)
			elseif event.element.name == item_train_view.selection_button_name then
				item_train_view.configure_train(player)
			end
		end
	end
)

script.on_event(defines.events.on_gui_switch_state_changed,
	function(event)
		local player = game.get_player(event.player_index)

		if event.element then
			if event.element.name == fluid_station_view.direction_switch_name then
				fluid_station_view.configure_train_station(player)
			elseif event.element.name == item_station_view.direction_switch_name then
				item_station_view.configure_train_station(player)
			end
		end
	end
)

script.on_event(defines.events.on_gui_click,
	function(event)
		local player = game.get_player(event.player_index)

		if event.element then
			if event.element.name == "close_button" then
				if event.element.parent.parent.name == dashboard.name then
					dashboard.toggle(player)
				elseif event.element.parent.parent.name == fluid_station_view.name then
					fluid_station_view.toggle(player)
				elseif event.element.parent.parent.name == fluid_train_view.name then
					fluid_train_view.toggle(player)
				elseif event.element.parent.parent.name == item_station_view.name then
					item_station_view.toggle(player)
				elseif event.element.parent.parent.name == item_train_view.name then
					item_train_view.toggle(player)
				end
			end
		end
	end
)

script.on_event(defines.events.on_train_schedule_changed,
	function(event)
		if event.train.locomotives.front_movers[1].name == "bwtc-transportation-train" then
			train_behavior.evaluate_transportation_train_command(event.train)
		end
	end
)
