function create_item(name, from_type, from_item)
	
	local item = table.deepcopy(data.raw[from_type][from_item])
	item.localised_description = {"item-description." .. name}
	item.localised_name = {"item-name." .. name}
	item.name = name
	item.place_result = name

	return item

end