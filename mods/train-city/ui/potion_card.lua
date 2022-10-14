potion_card = {}

potion_card.add_card_to_table = function (model, potions_table)
	local sprite_path = "item/" .. model.name
	local card_frame = potions_table.add{
		type = "frame",
		direction = "vertical",
	}
	local line_item = card_frame.add{
		type = "flow",
		direction = "horizontal",
		style = "bwtc_potion_metrics_line_item",
	}
	line_item.add{
		type = "sprite-button",
		sprite = (sprite_path),
		tags = {
			action = "show_potion_metrics_detail",
			item = model.name,
		}
	}
	line_item.add{
		type = "label",
		caption = model.count,
	}
end
