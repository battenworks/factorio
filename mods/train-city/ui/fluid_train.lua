require("ui.train_gui")

local item_type = "fluid"
local gui_name = "bwtc_fluid_train_gui"
local selection_button_name = "bwtc_fluid_train_selection_button"

fluid_train_gui = {
	name = gui_name,
	selection_button_name = selection_button_name,
}

fluid_train_gui.toggle = function (player, entity)
	train_gui.toggle(player, entity, item_type, gui_name, selection_button_name)
end

fluid_train_gui.clear = function (player)
	train_gui.clear(player)
end

fluid_train_gui.configure_train = function (player)
	train_gui.configure_train(player)
end
