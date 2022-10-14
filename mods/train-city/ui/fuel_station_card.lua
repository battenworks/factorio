fuel_station_card = {}

fuel_station_card.add_card_to_table = function (model, fuel_stations_table)
	local card_frame = fuel_stations_table.add{
		type = "frame",
		direction = "vertical",
	}
	local line_item = card_frame.add{
		type = "flow",
		direction = "horizontal",
		style = "bwtc_potion_metrics_line_item",
	}
	line_item.add{
		type = "sprite",
		sprite = "item/rocket-fuel",
	}
	line_item.add{
		type = "label",
		caption = model.count,
	}
end
