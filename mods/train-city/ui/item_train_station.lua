local function get_global_player(player)
	return global.bwtc_players[player.index]
end

local name = "bwtc_item_train_station_window"

item_train_station = {
	name = name,

	new = function (player, global_player)
		local main_window = player.gui.screen.add{
			type = "frame",
			name = name,
			caption = "Item train stop",
		}
		main_window.style.size = { 400, 300 }
		main_window.auto_center = true

		player.opened = main_window
		global_player.elements.item_train_station_window = main_window
	end,

	toggle = function (player)
		local global_player = get_global_player(player) -- TODO: function is duplicated in item_trains_window.lua
		-- TODO: rename variable below
		local item_train_station_frame = global_player.elements.item_train_station_window

		if item_train_station_frame == nil then
			item_train_station.new(player, global_player)
		else
			item_train_station_frame.destroy()
			global_player.elements = {}
		end
	end,

	clear = function (player)
		local global_player = get_global_player(player)

		if global_player.elements.item_train_station_window ~= nil then
			item_train_station.toggle(player)
		end
	end
}