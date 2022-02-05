item_card = {
	add_card_to_table = function (card, item_table)
		local sprite_path = card.item_type == "item" and "item/" .. card.item.name or "fluid/" .. card.item.name
		local card_frame = item_table.add{
			type = "frame",
			direction = "vertical",
		}
		local card_header = card_frame.add{
			type = "flow",
			direction = "horizontal",
			style = "bwtc_item_card_header",
		}
		local sprite_button_container = card_header.add{
			type = "flow",
			direction = "vertical",
			style = "bwtc_item_card_sprite_button_container",
		}
		sprite_button_container.add{
			type = "sprite-button",
			sprite = (sprite_path),
			tags = {
				action = "show_item_card_detail",
				item = card.item.name,
			}
		}
		local station_label_container = card_header.add{
			type = "flow",
			direction = "vertical",
			style = "bwtc_item_card_station_label_container",
		}
		station_label_container.add{
			type = "label",
			caption = "Load stations: " .. card.load_station_count,
		}
		station_label_container.add{
			type = "label",
			caption = "Drop stations: " .. card.drop_station_count,
		}
		local card_footer = card_frame.add{
			type = "flow",
			direction = "horizontal",
			style = "bwtc_item_card_footer",
		}
		local train_label_container = card_footer.add{
			type = "flow",
			direction = "vertical",
			style = "bwtc_item_card_train_label_container",
		}
		train_label_container.add{
			type = "label",
			caption = "Trains: " .. card.configured_train_count,
			style = "bwtc_item_card_train_label",
		}
	end
}
