require("ui.train_gui")

local item_type = "fluid"

fluid_train = {
	name = train_gui.name,
	selection_button_name = train_gui.selection_button_name,
}

fluid_train.toggle = function (player, entity)
	train_gui.toggle(player, entity, item_type)
end

fluid_train.clear = function (player)
	train_gui.clear(player)
end

fluid_train.configure_train = function (player)
	train_gui.configure_train(player)
end
