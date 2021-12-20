function create_recipe(for_name, from_item)

	local recipe = table.deepcopy(data.raw["recipe"][from_item])
	recipe.localised_name = {"recipe-name." .. for_name}
	recipe.name = for_name
	recipe.result = for_name

	return recipe

end