function parse_selected_item(schedule, item_type)
	selected_item = nil

	if schedule then
		local station_name = schedule.records[1].station
		local words = {}

		for word in string.gmatch(station_name, "%S+") do
			table.insert(words, word)
		end

		if item_type == "fluid" then
			selected_item = game.fluid_prototypes[words[1]] and words[1] or nil
		elseif item_type == "item" then
			selected_item = game.item_prototypes[words[1]] and words[1] or nil
		end
	end

	return selected_item
end

function render_station_list(container, schedule)
	container.clear()
	local station_list = container.add{
		type = "table",
		column_count = 1,
	}
	for _, record in pairs(schedule.records) do
		station_list.add{
			type = "label",
			caption = record.station,
			style = "bwtc_train_station_line_item",
		}
	end
end
