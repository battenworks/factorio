require("ui.train_view")

local item_type = "item"
local view_name = "bwtc_item_train_view"
local selection_button_name = "bwtc_item_train_selection_button"

item_train_view = {
	name = view_name,
	selection_button_name = selection_button_name,
}

item_train_view.toggle = function (player, entity)
	train_view.toggle(player, entity, item_type, view_name, selection_button_name)
end

item_train_view.clear = function (player)
	train_view.clear(player)
end

item_train_view.configure_train = function (player)
	train_view.configure_train(player)
end
