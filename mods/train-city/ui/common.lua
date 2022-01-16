global_player = {
	get = function (player)
		return global.item_trains[player.index]
	end
}

function parse_station_name(station_name)
	local words = {}

	for word in string.gmatch(station_name, "%S+") do
		table.insert(words, word)
	end

	local selected_item = game.item_prototypes[words[1]] and words[1] or nil

	return selected_item
end
