local grid_manager = require "grid"
local snake_manager = require "snake"
local modal = require "modal"
local text = require "text"
local name_selector = require "name_selector"
local menu = require "menu"
local scores = require "scores"

local GAME_SIZE = 400
local CELL_COUNT = 10
local CELL_PADDING = 5
local INITIAL_SPEED = 0.5
local MAX_SPEED = 0.1
local SPEED_INCREMENT = 0.01

local grid
local ui_modal

local game = {}
local score = 0
local state = "PLAYING"

Signal.register("eat", function()
    score = score + 1
end)

local function reset_game()
    local snake = snake_manager.newSnake(
        math.floor(CELL_COUNT / 2),
        math.floor(CELL_COUNT / 2),
        INITIAL_SPEED,
        MAX_SPEED,
        SPEED_INCREMENT,
        grid
    )
    grid:attach_snake(snake)
    state = "PLAYING"
    score = 0
end

local function high_score(next_state)
    ui_modal = modal.new_modal({
        text.new_text("NEW HIGH SCORE", Fonts.xlarge),
        text.new_text("Score: " .. string.format("%03d", score), Fonts.large),
        text.new_text("Enter your name", Fonts.large),
        name_selector.new_name_selector(function(name)
            scores.add_high_score(name, score)
            next_state()
        end),
        text.new_text("Press enter to continue", Fonts.default),
    }, 20)
    state = "HIGH_SCORE"
end

local function game_over()
    ui_modal = modal.new_modal({
        text.new_text("GAME OVER", Fonts.xlarge),
        text.new_text("Score: " .. string.format("%03d", score), Fonts.large),
        text.new_text(scores.is_high_score(score) and "New high score!" or "", Fonts.default),
        menu.new_menu({
            {
                text = text.new_text("Restart", Fonts.large),
                action = reset_game,
            },
            {
                text = text.new_text("Main menu", Fonts.large),
                action = function()
                    Gamestate.switch(States["main_menu"])
                end
            }
        }, 10),
    }, 20)
    state = "GAME_OVER"
end

local function pause()
    ui_modal = modal.new_modal({
        text.new_text("PAUSED", Fonts.xlarge),
        menu.new_menu({
            {
                text = text.new_text("Resume", Fonts.large),
                action = function()
                    state = "PLAYING"
                end
            },
            {
                text = text.new_text("Restart", Fonts.large),
                action = reset_game
            },
            {
                text = text.new_text("Main menu", Fonts.large),
                action = function()
                    Gamestate.switch(States["main_menu"])
                end
            }
        }, 10)
    }, 20)
    state = "PAUSED"
end

Signal.register("die", function()
    if scores.is_high_score(score) then
        high_score(game_over)
    else
        game_over()
    end
end)

Signal.register("win", function()
    state = "WIN"
end)

local function draw_score()
    local score_display = string.format("%03d", score)
    local score_width = Fonts.xlarge:getWidth(score_display)

    local x = love.graphics.getWidth() / 2 - score_width / 2
    local y = 50

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(Fonts.xlarge)
    love.graphics.print(score_display, x, y)
end

function game:enter()
    grid = grid_manager.newGrid(
        CELL_COUNT,
        love.graphics.getWidth() / 2,
        love.graphics.getHeight() / 2,
        GAME_SIZE,
        CELL_PADDING
    )

    reset_game()
end

function game:update(dt)
    if state == "PLAYING" then
        grid:update(dt)
    else
        ui_modal:update(dt)
    end
end

function game:draw()
    grid:draw()
    draw_score()

    if state ~= "PLAYING" then
        local w, h = ui_modal:get_size()
        local x = love.graphics.getWidth() / 2 - w / 2
        local y = love.graphics.getHeight() / 2 - h / 2
        ui_modal:draw(x, y)
    end
end

function game:keypressed(key)
    if state == "PLAYING" then
        if key == "escape" then
            pause()
        end
    else
        ui_modal:keypressed(key)
    end
end

return game
