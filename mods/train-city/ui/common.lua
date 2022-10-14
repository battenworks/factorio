common = {}

common.get_global_player = function (player)
	return global.train_city[player.index]
end

common.add_title_bar_to_view = function (title, view)
	local title_bar = view.add{ type = "flow", direction = "horizontal" }
	title_bar.name = "title_bar"
	title_bar.drag_target = view

	local title_label = title_bar.add{ type = "label" }
	title_label.name = "title_label"
	title_label.caption = title
	title_label.ignored_by_interaction = true
	title_label.style = "frame_title"

	local drag_handle = title_bar.add{ type = "empty-widget" }
	drag_handle.name = "drag_handle"
	drag_handle.ignored_by_interaction = true
	drag_handle.style = "draggable_space_header"
	drag_handle.style.height = 24
	drag_handle.style.horizontally_stretchable = true
	drag_handle.style.right_margin = 4

	local close_button = title_bar.add{ type = "sprite-button" }
	close_button.name = "close_button"
	close_button.clicked_sprite = "utility/close_black"
	close_button.hovered_sprite = "utility/close_black"
	close_button.sprite = "utility/close_white"
	close_button.style = "frame_action_button"
	close_button.tooltip = { "bwtc.close-button-caption" }
end
