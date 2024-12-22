local spacer = {}

function spacer.new_spacer(height)
    local spacer = {}

    function spacer:get_size()
        return 1, self.height
    end

    function spacer:draw(x, y)
    end

    function spacer:update(dt)
    end

    function spacer:keypressed(key)
    end

    return spacer
end

return spacer
