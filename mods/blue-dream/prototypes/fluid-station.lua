require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")

local name = "bwbd-fluid-station"

local entity = clone_entity(name, "train-stop", "train-stop")
entity.color = { 0.0, 0.47, 0.94, 0.5 }

local item = clone_item(name, "item", "train-stop")
item.icon = "__blue-dream__/graphics/fluid-station.png"

local recipe = clone_recipe(name, "train-stop")
recipe.ingredients = {
	{ type = "item", name = "train-stop", amount = 1 },
	{ type = "item", name = "advanced-circuit", amount = 2 },
}
recipe.enabled = true

data:extend {
	entity,
	item,
	recipe
}
