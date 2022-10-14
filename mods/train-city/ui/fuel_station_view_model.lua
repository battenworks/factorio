fuel_station_view_model = {}

fuel_station_view_model.add_view_model_to_table = function (model, fuel_stations_table)
	local view_model_frame = fuel_stations_table.add{
		type = "frame",
		direction = "vertical",
	}
	local line_item = view_model_frame.add{
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
