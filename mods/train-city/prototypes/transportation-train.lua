require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")

local name = "tc-transportation-train"

local entity = create_entity(name, "locomotive", "locomotive")

local item = create_item(name, "item-with-entity-data", "locomotive")

local ingredients = {
	{"locomotive", 1},
	{"nuclear-fuel", 3}
}
local recipe = create_recipe(name, "locomotive", ingredients, true)

data:extend{
  entity,
	item,
	recipe
}