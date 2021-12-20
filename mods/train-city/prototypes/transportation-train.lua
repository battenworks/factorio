require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")

local name = "tc-transportation-train"

local entity = create_entity(name, "locomotive", "locomotive")
entity.burner = nil
entity.energy_source = {type = "void"}
entity.max_power = "666kW"

local item = create_item(name, "item-with-entity-data", "locomotive")
item.icon = "__train-city__/graphics/transportation-train.png"

local recipe = create_recipe(name, "locomotive")
recipe.ingredients = {
	{"locomotive", 1},
	{"nuclear-fuel", 1}
}
recipe.enabled = true

data:extend{
	entity,
	item,
	recipe
}