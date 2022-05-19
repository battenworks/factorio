global_player = {
	get = function (player)
		return global.train_city[player.index]
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

function add_title_bar_to_gui(title, gui)
	local title_bar = gui.add{
		type = "flow",
		direction = "horizontal",
	}
	title_bar.name = "title_bar"
	title_bar.style.horizontally_stretchable = true

	local title_label = title_bar.add{
		type = "label",
		caption = title,
	}
	title_label.name = "title_label"
	title_label.ignored_by_interaction = true
	title_label.style = "frame_title"

	local drag_handle = title_bar.add{
		type = "empty-widget"
	}
	drag_handle.name = "drag_handle"
	drag_handle.drag_target = gui
	drag_handle.style = "draggable_space"
	drag_handle.style.height = 24
	drag_handle.style.width = 830

	local close_button = title_bar.add{ type = "sprite-button" }
	close_button.name = "close_button"
	close_button.clicked_sprite = "utility/close_black"
	close_button.hovered_sprite = "utility/close_black"
	close_button.sprite = "utility/close_white"
	close_button.style = "frame_action_button"
	close_button.tooltip = { "bwtc.close-button-caption" }
	-- actions = { on_click = { }},
end
