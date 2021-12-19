require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")

local name = "tc-item-train"

local entity = create_entity(name, "locomotive", "locomotive")

local item = create_item(name, "item-with-entity-data", "locomotive")

local ingredients = {
	{"locomotive", 1},
	{"advanced-circuit", 2}
}
local recipe = create_recipe(name, "locomotive", ingredients, true)

data:extend{
  entity,
	item,
	recipe
}