local function get_global_player(player)
	return global.bwtc_players[player.index]
end

local function initialize_global_player(player)
	global.bwtc_players[player.index] = { elements = {} }
end

local function build_interface(player)
	local player_global = get_global_player(player)

	local screen_element = player.gui.screen
	local main_frame = screen_element.add{type="frame", name="bwtc_main_frame", caption={"bwtc.hello_world"}}
	main_frame.style.size = {400, 200}
	main_frame.auto_center = true

	player.opened = main_frame
	player_global.elements.main_frame = main_frame
end

local function toggle_interface(player)
	local player_global = get_global_player(player)
	local main_frame = player_global.elements.main_frame

	if main_frame == nil then
		build_interface(player)
	else
		main_frame.destroy()
		player_global.elements = {}
	end
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
				local player_global = get_global_player(player)
				if player_global.elements.main_frame ~= nil then
					toggle_interface(player)
				end
			end
		end
	end
)

script.on_event(defines.events.on_player_created,
	function(event)
		local player = game.get_player(event.player_index)
		initialize_global_player(player)
	end
)

script.on_event(defines.events.on_player_removed,
	function(event)
		global.bwtc_players[event.player_index] = nil
	end
)

script.on_event("bwtc_toggle_main_window",
	function(event)
		local player = game.get_player(event.player_index)
		toggle_interface(player)
	end
)
