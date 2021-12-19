function create_entity(name, from_type, from_item)
	
	local entity = table.deepcopy(data.raw[from_type][from_item])
	entity.name = name
	entity.localised_name = {"entity-name." .. name}

	return entity

end