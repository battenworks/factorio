function clone_recipe(for_name, from_recipe)
	local recipe = table.deepcopy(data.raw["recipe"][from_recipe])
	recipe.localised_name = { "recipe-name." .. for_name }
	recipe.name = for_name
	recipe.results = {
        { type = "item", name = for_name, amount = 1 }
    }

	return recipe
end