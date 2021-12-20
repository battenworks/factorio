require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")

local name = "tc-item-train"

local entity = create_entity(name, "locomotive", "locomotive")

local item = create_item(name, "item-with-entity-data", "locomotive")
item.icon = "__train-city__/graphics/item-train.png"

local recipe = create_recipe(name, "locomotive")
recipe.ingredients = {
	{"locomotive", 1},
	{"advanced-circuit", 2}
}
recipe.enabled = true

data:extend{
	entity,
	item,
	recipe
}