require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")

local name = "tc-item-train-station"

local entity = create_entity(name, "train-stop", "train-stop")

local item = create_item(name, "item", "train-stop")

local ingredients = {
	{"train-stop", 1},
	{"advanced-circuit", 2}
}
local recipe = create_recipe(name, "train-stop", ingredients, true)

data:extend{
  entity,
	item,
	recipe
}