local entity = table.deepcopy(data.raw["locomotive"]["locomotive"])
entity.name = "tc-item-train"

local item = table.deepcopy(data.raw["item-with-entity-data"]["locomotive"])
item.name = entity.name

local recipe = table.deepcopy(data.raw["recipe"]["locomotive"])
recipe.name = entity.name
recipe.enabled = true
recipe.ingredients = {
	{"locomotive", 1},
	{"advanced-circuit", 2}
}
recipe.placeresult = item.name
recipe.result = item.name

data:extend{
  entity,
	item,
	recipe
}