local modal = {}

function modal.new_modal(items, padding)
    function modal:get_size()
        local height = 0
        local width = 0
        for i, item in ipairs(items) do
            local item_width, item_height = item:get_size()
            if item_width > width then
                width = item_width
            end
            height = height + item_height
        end
        return width + padding * 2, height + padding * #items
    end

    function modal:draw(x, y)
        local width, height = self:get_size()
        love.graphics.setColor(0, 0, 0, 0.2)
        love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

        love.graphics.setColor(1, 0, 1)
        love.graphics.rectangle("fill", x, y, width, height + padding)

        local first_item = items[1]
        local _, first_height = first_item.get_size()

        love.graphics.setColor(0.25, 0, 0.25)
        love.graphics.rectangle("fill", x+padding/2, y+first_height+padding, width-padding, height-padding/2-first_height)

        x = x + padding
        y = y + padding

        for i, item in ipairs(items) do
            item:draw(x, y)
            local _, item_height = item.get_size()
            y = y + item_height + padding
        end
    end

    function modal:keypressed(key)
        for i, item in ipairs(items) do
            item:keypressed(key)
        end
    end

    function modal:update(dt)
        for i, item in ipairs(items) do
            item:update(dt)
        end
    end

    return modal
end

return modal
