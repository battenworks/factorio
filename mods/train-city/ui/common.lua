global_player = {
	get = function (player)
		return global.item_trains[player.index]
	end
}

function write_to_screen(any)
	game.players[1].print(any)
end
