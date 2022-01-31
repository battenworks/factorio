require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")

local name = "bwtc-fluid-station"

local entity = create_entity(name, "train-stop", "train-stop")
entity.color = { 0.0, 0.47, 0.94, 0.5 }

local item = create_item(name, "item", "train-stop")
item.icon = "__train-city__/graphics/fluid-station.png"

local recipe = create_recipe(name, "train-stop")
recipe.ingredients = {
	{ "train-stop", 1 },
	{ "advanced-circuit", 2 },
}
recipe.enabled = true

data:extend{
	entity,
	item,
	recipe
}
