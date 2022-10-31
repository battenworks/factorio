require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")

local name = "bwtc-fluid-train"

local entity = create_entity(name, "locomotive", "locomotive")
entity.color = { 0.0, 0.47, 0.94, 0.5 }

local item = create_item(name, "item-with-entity-data", "locomotive")
item.icon = "__train-city__/graphics/fluid-train.png"

local recipe = create_recipe(name, "locomotive")
recipe.ingredients = {
	{ "locomotive", 1 },
	{ "advanced-circuit", 2 },
}
recipe.enabled = true

data:extend {
	entity,
	item,
	recipe
}
