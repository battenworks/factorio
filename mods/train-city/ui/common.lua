global_player = {
	get = function (player)
		return global.item_trains[player.index]
	end
}

function write_to_screen(payload)
	local message

	if type(payload) == "string" then
		message = payload
	else
		message = serpent.block(payload)
	end

	game.players[1].print(message)
end
