local scores_manager = require "scores"
local text = require "text"
local high_scores = {}

local scores

local title_text
local escape_text
local scores_texts = {}

local function format_score(score)
    return score.name .. " . . . . . " .. string.format("%03d", score.score)
end

function high_scores:enter()
    scores = scores_manager.get_high_scores()
    title_text = text.new_text("High Scores", Fonts.xlarge)
    escape_text = text.new_text("Press ESC to return to the main menu", Fonts.large)

    local font = Fonts.xlarge
    local color = {0, 1, 1}
    for i, score in ipairs(scores) do
        scores_texts[i] = text.new_text(format_score(score), font, color)
        font = Fonts.large
        color = {1, 1, 1}
    end
end

function high_scores:draw()
    local cx = (love.graphics.getWidth()) / 2
    local cy = (love.graphics.getHeight()) / 2
    local scores_height = Fonts.large:getHeight() * scores_manager.MAX_SCORES

    local title_width, _ = title_text:get_size()
    local escape_width, escape_height = escape_text:get_size()

    title_text:draw(cx - title_width / 2, 20)

    local y = cy - scores_height / 2
    for i, score_text in ipairs(scores_texts) do
        local score_width, score_height = score_text:get_size()
        score_text:draw(cx - score_width / 2, y)
        y = y + score_height
    end

    escape_text:draw(cx - escape_width / 2, love.graphics.getHeight() - escape_height - 20)
end

function high_scores:keypressed(key)
    if key == "escape" then
        Gamestate.switch(States["main_menu"])
    end
end

return high_scores
