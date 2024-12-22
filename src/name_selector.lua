local text = require "text"

local name_selector = {}

local chars = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"}

function name_selector.new_name_selector(on_select)
    local name_selector = {}

    name_selector.characters = {
        text.new_text("A", Fonts.xlarge),
        text.new_text("A", Fonts.xlarge),
        text.new_text("A", Fonts.xlarge),
    }
    name_selector.char_indexes = {1, 1, 1}
    name_selector.cursor = 1

    local function next_char()
        local idx = name_selector.cursor
        name_selector.char_indexes[idx] = name_selector.char_indexes[idx] + 1
        if name_selector.char_indexes[idx] > #chars then
            name_selector.char_indexes[idx] = 1
        end
        name_selector.characters[idx].text = chars[name_selector.char_indexes[idx]]
    end

    local function prev_char()
        local idx = name_selector.cursor
        name_selector.char_indexes[idx] = name_selector.char_indexes[idx] - 1
        if name_selector.char_indexes[idx] < 1 then
            name_selector.char_indexes[idx] = #chars
        end
        name_selector.characters[idx].text = chars[name_selector.char_indexes[idx]]
    end

    function name_selector:get_size()
        local width = 0
        local height = 0
        for i, character in ipairs(name_selector.characters) do
            local char_width, char_height = character:get_size()
            width = width + char_width
            if char_height > height then
                height = char_height
            end
        end
        return width, height
    end

    function name_selector:get_name()
        return name_selector.characters[1].text .. name_selector.characters[2].text .. name_selector.characters[3].text
    end

    function name_selector:draw(x, y)
        for i, character in ipairs(self.characters) do
            if name_selector.cursor == i then
                character.color = {0, 1, 1}
            else
                character.color = {1, 1, 1}
            end

            local char_width, _ = character:get_size()
            character:draw(x, y)
            x = x + char_width
        end
    end

    function name_selector:update(dt)
    end

    function name_selector:keypressed(key)
        if key == "left" then
            self.cursor = self.cursor - 1
            if self.cursor < 1 then
                self.cursor = 3
            end
        elseif key == "right" then
            self.cursor = self.cursor + 1
            if self.cursor > 3 then
                self.cursor = 1
            end
        elseif key == "up" then
            prev_char()
        elseif key == "down" then
            next_char()
        elseif key == "return" or key == "space" then
            on_select(self:get_name())
        end
    end

    return name_selector
end

return name_selector
