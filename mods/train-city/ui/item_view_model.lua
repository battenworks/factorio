item_view_model = {}

item_view_model.add_view_model_to_table = function(model, item_table)
	local sprite_path = model.item_type == "item" and "item/" .. model.item.name or "fluid/" .. model.item.name
	local view_model_frame = item_table.add {
		type = "frame",
		direction = "vertical",
	}
	local view_model_header = view_model_frame.add {
		type = "flow",
		direction = "horizontal",
		style = "bwtc_item_view_model_header",
	}
	local sprite_button_container = view_model_header.add {
		type = "flow",
		direction = "vertical",
		style = "bwtc_item_view_model_sprite_button_container",
	}
	sprite_button_container.add {
		type = "sprite",
		sprite = (sprite_path),
		tags = {
			action = "show_item_view_model_detail",
			item = model.item.name,
		}
	}
	local station_label_container = view_model_header.add {
		type = "flow",
		direction = "vertical",
		style = "bwtc_item_view_model_station_label_container",
	}
	station_label_container.add {
		type = "label",
		caption = "Load stations: " .. model.load_station_count,
	}
	station_label_container.add {
		type = "label",
		caption = "Drop stations: " .. model.drop_station_count,
	}
	local view_model_footer = view_model_frame.add {
		type = "flow",
		direction = "horizontal",
		style = "bwtc_item_view_model_footer",
	}
	local train_label_container = view_model_footer.add {
		type = "flow",
		direction = "vertical",
		style = "bwtc_item_view_model_train_label_container",
	}
	train_label_container.add {
		type = "label",
		caption = "Trains: " .. model.configured_train_count,
		style = "bwtc_item_view_model_train_label",
	}
end
