local NAME = "tc-item-train-station"

local entity = table.deepcopy(data.raw["train-stop"]["train-stop"])
entity.name = NAME
entity.localised_name = {"entity-name." .. NAME}

local item = table.deepcopy(data.raw["item"]["train-stop"])
item.name = NAME
item.localised_name = {"item-name." .. NAME}

local recipe = table.deepcopy(data.raw["recipe"]["train-stop"])
recipe.name = NAME
recipe.localised_name = {"recipe-name." .. NAME}
recipe.enabled = true
recipe.ingredients = {
	{"train-stop", 1},
	{"advanced-circuit", 2}
}
recipe.placeresult = NAME
recipe.result = NAME

data:extend{
  entity,
	item,
	recipe
}