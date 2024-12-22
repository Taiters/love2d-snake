local text = require "text"
local menu = require "menu"

local main_menu = {}

local ui_menu

function main_menu:enter()
    ui_menu = menu.new_menu({
        {
            text = text.new_text("Start", Fonts.xlarge),
            action = function() Gamestate.switch(States["game"]) end
        },
        {
            text = text.new_text("High scores", Fonts.xlarge),
            action = function() Gamestate.switch(States["high_scores"]) end
        },
        {
            text = text.new_text("Quit", Fonts.xlarge),
            action = function() love.event.quit() end
        },
    }, 1)
end

function main_menu:draw()
    local cx = (love.graphics.getWidth()) / 2
    local cy = (love.graphics.getHeight()) / 2

    local menu_width, menu_height = ui_menu.get_size()

    ui_menu:draw(cx - menu_width / 2, cy - menu_height / 2)
end

function main_menu:keypressed(key)
    ui_menu:keypressed(key)
end

function main_menu:update(dt)
    ui_menu:update(dt)
end

return main_menu
