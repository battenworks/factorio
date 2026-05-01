data:extend({
	{
		type = "technology",
		name = "blue-dream",
		icon = "__blue-dream__/graphics/david-avatar.png",
		icon_size = 200,
		icon_mipmaps = 4,
		prerequisites = {
			"automated-rail-transportation",
			"electric-energy-distribution-2",
			"logistic-robotics",
		},
		effects = {
			{
				type = "unlock-recipe",
				recipe = "bwbd-fluid-station",
			},
			{
				type = "unlock-recipe",
				recipe = "bwbd-fluid-train",
			},
			{
				type = "unlock-recipe",
				recipe = "bwbd-item-station",
			},
			{
				type = "unlock-recipe",
				recipe = "bwbd-item-train",
			},
			{
				type = "unlock-recipe",
				recipe = "bwbd-transportation-train",
			},
		},
		unit = {
			count = 500,
			ingredients = {
				{ "automation-science-pack", 1 },
				{ "logistic-science-pack", 1 },
				{ "chemical-science-pack", 1 },
			},
			time = 30,
		},
		order = "c-g-c"
	}
})