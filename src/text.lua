local text = {}

function text.new_text(text, font, color)
    local text = {
        text = text,
        font = font,
        color = color or {1, 1, 1},
    }

    function text:draw(x, y)
        love.graphics.setFont(font)
        love.graphics.setColor(self.color[1], self.color[2], self.color[3])
        love.graphics.print(text.text, x, y)
    end

    function text:get_size()
        return font:getWidth(text.text), font:getHeight(text.text)
    end

    function text:update(dt)
    end

    function text:keypressed(key)
    end

    return text
end


return text
