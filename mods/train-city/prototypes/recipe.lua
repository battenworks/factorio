function create_recipe(for_name, from_item)

	local recipe = table.deepcopy(data.raw["recipe"][from_item])
	recipe.name = for_name
	recipe.localised_name = {"recipe-name." .. for_name}
	recipe.placeresult = for_name
	recipe.result = for_name

	return recipe

end