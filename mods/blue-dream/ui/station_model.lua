station_model = {}

station_model.new = function(station)
    local item = {
        type = get_item_type(station.name)
    }

    local item_name, stack_size, load_direction = parse_backer_name(station.backer_name, item.type)
    item.name = item_name
    item.stack_size = stack_size

    return {
        item = item,
        capacity = get_station_capacity(item),
        load_direction = load_direction,
        inventory = get_item_count(station, item),
        train_capacity = get_train_capacity(item),
    }
end

function get_item_type(station_name)
    if station_name == "bwbd-item-station" then
        return "item"
    end

    return "fluid"
end

function parse_backer_name(backer_name, item_type)
    item_name = nil
    stack_size = 0
    local words = {}

    for word in string.gmatch(backer_name, "%S+") do
        table.insert(words, word)
    end

    if item_type == "item" then
        item = prototypes.item[words[1]] or nil
        if item ~= nil then
            item_name = item.name or nil
            stack_size = item.stack_size or 0
        end
    else
        item = prototypes.fluid[words[1]] or nil
        if item ~= nil then
            item_name = item.name or nil
        end
    end

    return item_name, stack_size, words[2]
end

function get_item_count(station, item)
    local item_count = 0

    local green_signals = station.get_signals(defines.wire_connector_id.circuit_green)
    if green_signals then
        for _, signal in pairs(green_signals) do
            if signal.signal.name == item.name then
                item_count = signal.count
            end
        end
    end

    if item_count == 0 then
        local red_signals = station.get_signals(defines.wire_connector_id.circuit_red)
        if red_signals then
            for _, signal in pairs(red_signals) do
                if signal.signal.name == item.name then
                    item_count = signal.count
                end
            end
        end
    end

    return item_count
end

function get_train_capacity(item)
    local train_capacity = 0

    if item.type == "item" then
        train_capacity = item.stack_size * 40 * 2
    elseif item.type == "fluid" then
        train_capacity = 50000
    end

    return train_capacity
end

function get_station_capacity(item)
    local station_capacity = 0

    if item.type == "item" then
        station_capacity = item.stack_size * 48 * 12
    elseif item.type == "fluid" then
        station_capacity = 150000
    end

    return station_capacity
end
