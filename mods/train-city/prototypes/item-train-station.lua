local prototype_name = "tc-item-train-station"

local entity = table.deepcopy(data.raw["train-stop"]["train-stop"])
entity.name = prototype_name
entity.localised_name = {"entity-name." .. prototype_name}

local item = table.deepcopy(data.raw["item"]["train-stop"])
item.name = prototype_name
item.localised_name = {"item-name." .. prototype_name}

local recipe = table.deepcopy(data.raw["recipe"]["train-stop"])
recipe.name = prototype_name
recipe.localised_name = {"recipe-name." .. prototype_name}
recipe.enabled = true
recipe.ingredients = {
	{"train-stop", 1},
	{"advanced-circuit", 2}
}
recipe.placeresult = prototype_name
recipe.result = prototype_name

data:extend{
  entity,
	item,
	recipe
}