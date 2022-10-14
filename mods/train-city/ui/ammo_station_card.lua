ammo_station_card = {}

ammo_station_card.add_card_to_table = function (model, ammo_stations_table)
	local card_frame = ammo_stations_table.add{
		type = "frame",
		direction = "vertical",
	}
	local line_item = card_frame.add{
		type = "flow",
		direction = "horizontal",
		style = "bwtc_potion_metrics_line_item",
	}
	line_item.add{
		type = "sprite-button",
		sprite = "item/uranium-rounds-magazine",
	}
	line_item.add{
		type = "label",
		caption = model.count,
	}
end
