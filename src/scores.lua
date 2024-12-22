scores = {
    MAX_SCORES = 5,
    FILE = "scores.dat"
}

local function serialize(scores)
    local data = ""
    for i, score in ipairs(scores) do
        data = data .. score.name .. "," .. score.score .. "\n"
    end
    return data
end

local function deserialize(data)
    local scores = {}
    for line in data:gmatch("[^\n]+") do
        local name, score = line:match("([^,]+),([^,]+)")
        table.insert(scores, { name = name, score = tonumber(score) })
    end
    return scores
end

function scores.get_high_scores()
    if not scores.scores then
        if love.filesystem.getInfo(scores.FILE) then
            local data = love.filesystem.read(scores.FILE)
            scores.scores = deserialize(data)
        else
            scores.scores = {}
        end
    end
    return scores.scores
end

function scores.add_high_score(name, score)
    table.insert(scores.get_high_scores(), { name = name, score = score })
    table.sort(scores.get_high_scores(), function(a, b) return a.score > b.score end)
    if #scores.get_high_scores() > scores.MAX_SCORES then
        table.remove(scores.get_high_scores())
    end

    local data = serialize(scores.get_high_scores())
    local success, error = love.filesystem.write(scores.FILE, data)
    if not success then
        print("Error writing scores: " .. error)
    end
end

function scores.save()
end

function scores.is_high_score(score)
    local high_scores = scores.get_high_scores()
    if #high_scores < scores.MAX_SCORES then
        return true
    end
    for i, high_score in ipairs(high_scores) do
        if score > high_score.score then
            return true
        end
    end
    return false
end

return scores
