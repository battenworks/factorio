function create_recipe(for_name, from_item, ingredients, enabled)

	local recipe = table.deepcopy(data.raw["recipe"][from_item])
	recipe.name = for_name
	recipe.localised_name = {"recipe-name." .. for_name}
	recipe.enabled = enabled
	recipe.ingredients = ingredients
	recipe.placeresult = for_name
	recipe.result = for_name

	return recipe

end