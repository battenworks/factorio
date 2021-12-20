function create_entity(name, from_type, from_item)
	
	local entity = table.deepcopy(data.raw[from_type][from_item])
	entity.localised_description = {"entity-description." .. name}
	entity.localised_name = {"entity-name." .. name}
	entity.name = name

	return entity

end