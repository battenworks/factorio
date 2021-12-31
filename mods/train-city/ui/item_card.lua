item_card = {
	add_card_to_table = function (item, item_table)
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
			sprite = ("item/" .. item),
			tags = {
				action = "show_item_card_detail",
				item = item,
			}
		}
		local station_label_container = card_header.add{
			type = "flow",
			direction = "vertical",
			style = "bwtc_item_card_station_label_container",
		}
		station_label_container.add{
			type = "label",
			caption = "Load stations: 34",
		}
		station_label_container.add{
			type = "label",
			caption = "Drop stations: 35",
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
			caption = "Trains: 42",
			style = "bwtc_item_card_train_label",
		}
		train_label_container.add{
			type = "label",
			caption = "Fueling: 78",
			style = "bwtc_item_card_train_label",
		}
		local train_button_container = card_footer.add{
			type = "flow",
			direction = "vertical",
		}
		train_button_container.add{
			type = "button",
			caption = "Add Train",
		}
		train_button_container.add{
			type = "button",
			caption = "Remove Train",
		}
	end
}