require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")

local name = "bwbd-fluid-train"

local entity = clone_entity(name, "locomotive", "locomotive")
entity.color = { 0.0, 0.47, 0.94, 0.5 }

local item = clone_item(name, "item-with-entity-data", "locomotive")
item.icon = "__blue-dream__/graphics/fluid-train.png"

local recipe = clone_recipe(name, "locomotive")
recipe.ingredients = {
	{ type = "item", name = "locomotive", amount = 1 },
	{ type = "item", name = "advanced-circuit", amount = 2 },
}
recipe.enabled = true

data:extend {
	entity,
	item,
	recipe
}
