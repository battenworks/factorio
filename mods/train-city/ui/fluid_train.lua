require("ui.train_gui")

local item_type = "fluid"

fluid_train = {
	name = train_gui.name,
	selection_button_name = train_gui.selection_button_name,

	render_station_list = function (container, schedule)
		train_gui.render_station_list(container, schedule)
	end,
	new = function (player, global_player, entity)
		train_gui.new(player, global_player, entity, item_type)
	end,
	toggle = function (player, entity)
		train_gui.toggle(player, entity, item_type)
	end,
	clear = function (player)
		train_gui.clear(player)
	end,
	configure_train = function (player)
		train_gui.configure_train(player)
	end,
}
