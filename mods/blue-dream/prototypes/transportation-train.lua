require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")

local name = "bwbd-transportation-train"

local entity = clone_entity(name, "locomotive", "locomotive")
entity.burner = nil
entity.color = { 0.2, 1, 0, 0.5 }
entity.energy_source = { type = "void" }
entity.equipment_grid = nil
entity.max_power = "1210kW"

local item = clone_item(name, "item-with-entity-data", "locomotive")
item.icon = "__blue-dream__/graphics/transportation-train.png"
item.stack_size = 1

local recipe = clone_recipe(name, "locomotive")
recipe.ingredients = {
	{ type = "item", name = "locomotive", amount = 1 },
	{ type = "item", name = "nuclear-fuel", amount = 1 },
}
recipe.enabled = true

data:extend {
	entity,
	item,
	recipe
}
