require("ui.common")

local window_name = "bwtc_item_station_gui"
local choose_elem_button_name = "bwtc_item_station_selected_item"
local direction_switch_name = "bwtc_item_station_direction_switch"

local function parse_station_backer_name(backer_name)
	local words = {}

	for word in string.gmatch(backer_name, "%S+") do
		table.insert(words, word)
	end

	local selected_item = game.item_prototypes[words[1]] and words[1] or nil
	local selected_direction = words[2] == "load" and "right" or "left"

	return selected_item, selected_direction
end

item_station = {
	name = window_name,
	selected_item_control = choose_elem_button_name,
	selected_direction_control = direction_switch_name,

	new = function (player, global_player, entity)
		local selected_item, selected_direction = parse_station_backer_name(entity.backer_name)

		local main_window = player.gui.center.add{
			type = "frame",
			name = window_name,
			caption = { "entity-name.bwtc-item-station" },
			style = "bwtc_gui_main_window",
		}

		player.opened = main_window
		global_player.elements.item_station_gui = main_window
		global_player.entities.item_station_entity = entity

		local main_container = main_window.add{
			type = "frame",
			name = "main_container",
			direction = "vertical",
			style = "inside_shallow_frame_with_padding",
		}
		local selected_item_container = main_container.add{
			type = "flow",
			name = "selected_item_container",
			direction = "horizontal",
			style = "bwtc_item_station_selected_item_container",
		}
		selected_item_container.add{
			type = "label",
			caption = { "bwtc.item-caption" },
		}
		local choose_item_button = selected_item_container.add{
			type = "choose-elem-button",
			name = choose_elem_button_name,
			elem_type = "item",
		}
		choose_item_button.elem_value = selected_item
		local selected_direction_container = main_container.add{
			type = "flow",
			name = "selected_direction_container",
			direction = "horizontal",
			style = "bwtc_item_station_selected_direction_container",
		}
		selected_direction_container.add{
			type = "label",
			caption = { "bwtc.drop-caption" },
		}
		selected_direction_container.add{
			type = "switch",
			name = direction_switch_name,
		  switch_state = selected_direction,
		}
		selected_direction_container.add{
			type = "label",
			caption = { "bwtc.load-caption" },
		}

	end,

	toggle = function (player, entity)
		local global_player = global_player.get(player)
		local global_gui = global_player.elements.item_station_gui

		if global_gui == nil then
			item_station.new(player, global_player, entity)
		else
			global_gui.destroy()
			global_player.elements = {}
			global_player.entities = {}
		end
	end,

	clear = function (player)
		local global_player = global_player.get(player)

		if global_player.elements.item_station_gui ~= nil then
			item_station.toggle(player)
		end
	end,

	configure_train_station = function (player)
		local global_player = global_player.get(player)
		local global_gui = global_player.elements.item_station_gui
		local selected_item = global_gui.main_container.selected_item_container[choose_elem_button_name].elem_value
		local item = selected_item or "none"
		local selected_direction = global_gui.main_container.selected_direction_container[direction_switch_name].switch_state
		local direction = selected_direction == "left" and "drop" or "load"

		global_player.entities.item_station_entity.backer_name = item .. " " .. direction
		global_player.entities.item_station_entity.trains_limit = 1
	end
}