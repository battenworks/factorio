local prototype_name = "tc-transportation-train"

local entity = table.deepcopy(data.raw["locomotive"]["locomotive"])
entity.name = prototype_name
entity.localised_name = {"entity-name." .. prototype_name}

local item = table.deepcopy(data.raw["item-with-entity-data"]["locomotive"])
item.name = prototype_name
item.localised_name = {"item-name." .. prototype_name}

local recipe = table.deepcopy(data.raw["recipe"]["locomotive"])
recipe.name = prototype_name
recipe.localised_name = {"recipe-name." .. prototype_name}
recipe.enabled = true
recipe.ingredients = {
	{"locomotive", 1},
	{"nuclear-fuel", 3}
}
recipe.placeresult = prototype_name
recipe.result = prototype_name

data:extend{
  entity,
	item,
	recipe
}