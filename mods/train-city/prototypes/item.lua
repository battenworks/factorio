function create_item(name, from_type, from_item)
	
	local item = table.deepcopy(data.raw[from_type][from_item])
	item.name = name
	item.localised_name = {"item-name." .. name}

	return item

end