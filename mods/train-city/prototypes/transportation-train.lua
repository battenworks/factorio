require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")

local name = "bwtc-transportation-train"

local entity = create_entity(name, "locomotive", "locomotive")
entity.burner = nil
entity.color = { 0.2, 1, 0, 0.5 }
entity.energy_source = { type = "void" }
entity.equipment_grid = nil
entity.max_power = "1210kW"

local item = create_item(name, "item-with-entity-data", "locomotive")
item.icon = "__train-city__/graphics/transportation-train.png"
item.stack_size = 1

local recipe = create_recipe(name, "locomotive")
recipe.ingredients = {
	{ "locomotive", 1 },
	{ "nuclear-fuel", 1 },
}
recipe.enabled = true

data:extend{
	entity,
	item,
	recipe
}