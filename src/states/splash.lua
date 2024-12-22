local state = {}

local SPLASH_TIME = 5

function state:enter()
    self.time_in_state = 0
    self.text_location = { x = -200 }

    Timer.tween(2, self.text_location, { x = love.graphics.getWidth() + 20 }, "out-in-elastic", function()
        Gamestate.switch(States["game"])
    end)
end

function state:update(dt)
    self.time_in_state = self.time_in_state + dt
    if self.time_in_state >= SPLASH_TIME then
        self.time_in_state = 0
        love.event.push("change_state", "game")
    end

    Timer.update(dt)
end

function state:draw()
    love.graphics.setFont(Fonts.large)
    love.graphics.setColor(0, 1, 1)
    love.graphics.print("It's Snake", self.text_location.x, love.graphics.getHeight() / 2 - 50)
end

return state
