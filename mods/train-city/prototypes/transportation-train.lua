require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")

local name = "tc-transportation-train"

local entity = create_entity(name, "locomotive", "locomotive")

local item = create_item(name, "item-with-entity-data", "locomotive")
item.icons = {
	{
		icon = "__train-city__/graphics/transportation-train.png",
		icon_size = 64
	}
}

local recipe = create_recipe(name, "locomotive")
recipe.ingredients = {
	{"locomotive", 1},
	{"nuclear-fuel", 3}
}
recipe.enabled = true

data:extend{
  entity,
	item,
	recipe
}