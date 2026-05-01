require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")

local name = "bwbd-item-station"

local entity = clone_entity(name, "train-stop", "train-stop")
entity.color = { 0.2, 0, 1, 0.5 }

local item = clone_item(name, "item", "train-stop")
item.icon = "__blue-dream__/graphics/item-station.png"

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
