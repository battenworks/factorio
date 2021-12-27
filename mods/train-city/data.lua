require("prototypes.item-train")
require("prototypes.item-train-station")
require("prototypes.transportation-train")

local styles = data.raw["gui-style"].default

styles["bwtc_content_frame"] = {
	type = "frame_style",
	parent = "inside_shallow_frame_with_padding",
	vertically_stretchable = "on"
}

styles["bwtc_item_card"] = {
	type = "vertical_flow_style",
	vertically_stretchable = "on"
}

data:extend({
	{
		type = "custom-input",
		name = "bwtc_toggle_main_window",
		key_sequence = "CONTROL + T",
		order = "a"
	}
})