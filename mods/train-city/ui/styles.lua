local styles = data.raw["gui-style"].default

styles["bwtc_main_container"] = {
	type = "frame_style",
	vertically_stretchable = "on",
}

styles["bwtc_tabbed_pane"] = {
	type = "tabbed_pane_style",
	size = { 950, 580 },
}

styles["bwtc_item_card_header"] = {
	type = "horizontal_flow_style",
	bottom_margin = 5,
	horizontal_align = "center",
	horizontally_stretchable = "on",
}

styles["bwtc_item_card_sprite_button_container"] = {
	type = "vertical_flow_style",
	top_margin = 3,
}

styles["bwtc_item_card_station_label_container"] = {
	type = "vertical_flow_style",
	left_margin = 15,
}

styles["bwtc_item_card_footer"] = {
	type = "horizontal_flow_style",
	horizontal_align = "center",
	horizontally_stretchable = "on",
}

styles["bwtc_item_card_train_label_container"] = {
	type = "vertical_flow_style",
	horizontal_align = "right",
	right_margin = 15,
}

styles["bwtc_item_card_train_label"] = {
	type = "label_style",
	top_margin = 5,
}

styles["bwtc_view_main_window"] = {
	type = "frame_style",
	use_header_filler = false,
	horizontally_stretchable = "on",
	vertically_stretchable = "on",
}

styles["bwtc_station_selection_container"] = {
	type = "horizontal_flow_style",
	bottom_margin = 5,
	vertical_align = "center",
}

styles["bwtc_station_direction_container"] = {
	type = "horizontal_flow_style",
	vertical_align = "center",
}

styles["bwtc_train_selection_container"] = {
	type = "horizontal_flow_style",
	margin = 12,
	vertical_align = "center",
}

styles["bwtc_train_station_header"] = {
	type = "frame_style",
	bottom_padding = 5,
	horizontally_stretchable = "on",
}

styles["bwtc_train_station_header_label"] = {
	type = "label_style",
	left_margin = 5,
}

styles["bwtc_train_station_line_item"] = {
	type = "label_style",
	left_margin = 15,
}

styles["bwtc_potion_metrics_line_item"] = {
	type = "horizontal_flow_style",
	bottom_margin = 5,
	horizontally_stretchable = "on",
	top_margin = 5,
}
