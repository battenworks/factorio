data:extend({
	{
		type = "technology",
		name = "train-city",
		icon = "__train-city__/graphics/david-avatar.png",
		icon_size = 200,
		icon_mipmaps = 4,
		prerequisites = {
			"rail-signals",
			"electric-energy-distribution-2",
			"logistic-robotics",
		},
		effects = {
			{
				type = "unlock-recipe",
				recipe = "bwtc-fluid-station",
			},
			{
				type = "unlock-recipe",
				recipe = "bwtc-fluid-train",
			},
			{
				type = "unlock-recipe",
				recipe = "bwtc-item-station",
			},
			{
				type = "unlock-recipe",
				recipe = "bwtc-item-train",
			},
			{
				type = "unlock-recipe",
				recipe = "bwtc-transportation-train",
			},
		},
		unit = {
			count = 500,
			ingredients = {
				{"automation-science-pack", 1},
				{"logistic-science-pack", 1},
				{"chemical-science-pack", 1},
			},
			time = 30,
		},
		order = "c-g-c"
	}
})
