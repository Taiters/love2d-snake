Gamestate = require "hump.gamestate"
Timer = require "hump.timer"
Signal = require "hump.signal"

require "audio"

Fonts = {}
Audio = {}
States = {
    ["splash"] = require "states/splash",
    ["main_menu"] = require "states/main_menu",
    ["high_scores"] = require "states/high_scores",
    ["game"] = require "states/game",
}

local crt_shader
local crt_canvas
local t = 0

function init_fonts()
    Fonts.default = love.graphics.newFont("m6x11.ttf", 16)
    Fonts.large = love.graphics.newFont("m6x11.ttf", 32)
    Fonts.xlarge = love.graphics.newFont("m6x11.ttf", 48)
    love.graphics.setFont(Fonts.default)
end

function init_audio()
    Audio.eat = love.audio.newSource("eat.wav", "static")
    Audio.music = love.audio.newSource("music.mp3", "stream")
    Audio.menu_move = love.audio.newSource("menu_move.wav", "static")
    Audio.menu_select = love.audio.newSource("menu_select.wav", "static")

    Audio.music:setLooping(true)
    Audio.music:play()
end

function init_shaders()
    crt_shader = love.graphics.newShader("crt.glsl")
    crt_canvas = love.graphics.newCanvas()
end

function love.load()
    -- love.window.setFullscreen(true)
    love.window.setTitle("Snake - This time it's personal")

    init_fonts()
    init_audio()
    init_shaders()

    Gamestate.registerEvents {
        "keypressed",
        "update",
    }
    Gamestate.switch(States["main_menu"])
end

function love.update(dt)
    t = t + dt
    crt_shader:send("time", t)
end

function love.draw()
    crt_canvas:renderTo(function()
        love.graphics.clear(0.25, 0, 0.25)
        Gamestate.draw()
    end)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setShader(crt_shader)
    love.graphics.draw(crt_canvas)
    love.graphics.setShader()
end
