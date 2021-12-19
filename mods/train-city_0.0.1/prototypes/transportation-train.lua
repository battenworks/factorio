local NAME = "tc-transportation-train"

local entity = table.deepcopy(data.raw["locomotive"]["locomotive"])
entity.name = NAME
entity.localised_name = {"entity-name." .. NAME}

local item = table.deepcopy(data.raw["item-with-entity-data"]["locomotive"])
item.name = NAME
item.localised_name = {"item-name." .. NAME}

local recipe = table.deepcopy(data.raw["recipe"]["locomotive"])
recipe.name = NAME
recipe.localised_name = {"recipe-name." .. NAME}
recipe.enabled = true
recipe.ingredients = {
	{"locomotive", 1},
	{"nuclear-fuel", 3}
}
recipe.placeresult = NAME
recipe.result = NAME

data:extend{
  entity,
	item,
	recipe
}