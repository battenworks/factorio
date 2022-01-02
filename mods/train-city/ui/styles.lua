local styles = data.raw["gui-style"].default

styles["bwtc_item_scroll_pane"] = {
	type = "scroll_pane_style",
	padding = 10,
	vertically_stretchable = "on",
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

styles["bwtc_item_station"] = {
	type = "frame_style",
	use_header_filler = false,
	horizontally_stretchable = "on",
	vertically_stretchable = "on",
}
