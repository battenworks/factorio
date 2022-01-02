function create_recipe(for_name, from_recipe)
	local recipe = table.deepcopy(data.raw["recipe"][from_recipe])
	recipe.localised_name = { "recipe-name." .. for_name }
	recipe.name = for_name
	recipe.result = for_name

	return recipe
end