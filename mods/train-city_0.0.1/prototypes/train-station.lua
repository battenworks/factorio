local entity = table.deepcopy(data.raw["train-stop"]["train-stop"])
entity.name = "tc-item-train-station"

local item = table.deepcopy(data.raw["item"]["train-stop"])
item.name = entity.name

local recipe = table.deepcopy(data.raw["recipe"]["train-stop"])
recipe.name = entity.name
recipe.enabled = true
recipe.ingredients = {
	{"train-stop", 1},
	{"advanced-circuit", 2}
}
recipe.placeresult = item.name
recipe.result = item.name

data:extend{
  entity,
	item,
	recipe
}