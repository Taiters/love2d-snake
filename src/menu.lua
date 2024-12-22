local menu = {}

function menu.new_menu(items, spacing)
    for i, item in ipairs(items) do
        item.offset = 0
    end

    local menu = {}
    local selected_item = 1
    local timer = Timer.new()

    local pulse = function (item)
        timer:tween(0.05, item, {offset = 10}, "out-quad", function()
            timer:tween(0.1, item, {offset = 0}, "in-quad")
        end)
    end

    function menu:keypressed(key)
        if key == "up" then
            selected_item = selected_item - 1
            if selected_item < 1 then
                selected_item = #items
            end
            pulse(items[selected_item])
            Signal.emit("menu_move")
        elseif key == "down" then
            selected_item = selected_item + 1
            if selected_item > #items then
                selected_item = 1
            end
            pulse(items[selected_item])
            Signal.emit("menu_move")
        elseif key == "return" or key == "space" then
            items[selected_item].action()
            Signal.emit("menu_select")
        end
    end

    function menu:get_size()
        local height = 0
        local width = 0
        for i, item in ipairs(items) do
            local item_width, item_height = item.text:get_size()
            if item_width > width then
                width = item_width
            end
            height = height + item_height
        end
        return width, height + spacing * (#items - 1)
    end

    function menu:draw(x, y)
        for i, item in ipairs(items) do
            if i == selected_item then
                item.text.color = {0, 1, 1}
            else
                item.text.color = {1, 1, 1}
            end
            item.text:draw(x + item.offset, y)
            local _, item_height = item.text:get_size()
            y = y + item_height + spacing
        end
    end

    function menu:update(dt)
        timer:update(dt)
    end

    return menu
end

return menu
