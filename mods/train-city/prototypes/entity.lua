function create_entity(name, from_type, from_entity)
	local entity = table.deepcopy(data.raw[from_type][from_entity])
	entity.localised_description = { "entity-description." .. name }
	entity.localised_name = { "entity-name." .. name }
	entity.minable = { mining_time = 1, result = name }
	entity.name = name

	return entity
end