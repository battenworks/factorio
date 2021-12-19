require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")

local name = "tc-item-train-station"

local entity = create_entity(name, "train-stop", "train-stop")

local item = create_item(name, "item", "train-stop")
item.icons = {
	{
		icon = "__train-city__/graphics/item-train-station.png",
		icon_size = 64
	}
}

local recipe = create_recipe(name, "train-stop")
recipe.ingredients = {
	{"train-stop", 1},
	{"advanced-circuit", 2}
}
recipe.enabled = true

data:extend{
	entity,
	item,
	recipe
}