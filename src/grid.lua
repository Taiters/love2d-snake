local animations = require "animations"

local grid = {}

function grid.newGrid(cell_count, x, y, size, padding)
    local cell_size = size/cell_count
    local grid_timer = Timer:new()

    local grid = {
        cell_count = cell_count,
        cell_size = cell_size,
        half_cell_size = cell_size / 2,
        x = x,
        y = y,
        padding = padding,
        food = {},
        snake = nil
    }

    function grid:attach_snake(snake)
        self.snake = snake
        self:reset_food()
    end

    function grid:cell_to_coord(row, col)
        local offset_x = col * self.cell_size
        local offset_y = row * self.cell_size

        local x = (self.x - size / 2) + offset_x + self.cell_size / 2
        local y = (self.y - size / 2) + offset_y + self.cell_size / 2

        return x, y
    end

    function grid:draw_cell(row, col, scale)
        local cx, cy = self:cell_to_coord(row, col)
        local size = (self.half_cell_size - self.padding) * (scale or 1)
        local x = cx - size
        local y = cy - size

        love.graphics.rectangle("fill", x, y, size * 2, size * 2)
    end

    function grid:contains_food(row, col)
        if not self.food then
            return false
        end

        return self.food.x == col and self.food.y == row
    end

    function grid:reset_food()
        self.food.x = math.random(self.cell_count-1)
        self.food.y = math.random(self.cell_count-1)
        while self:check_food_collision() do
            self.food.x = math.random(self.cell_count-1)
            self.food.y = math.random(self.cell_count-1)
        end
        self.food.scale = 0
        animations.pulse(grid_timer, self.food, "scale", 1.25, 0.2, 0.1)
    end

    function grid:check_food_collision()
        for _, segment in ipairs(self.snake.segments) do
            if segment.x == self.food.x and segment.y == self.food.y then
                return true
            end
        end
        return false
    end

    function grid:draw()
        love.graphics.setColor(0.35, 0, 0.35)
        for row = 0, self.cell_count - 1 do
            for col = 0, self.cell_count - 1 do
                self:draw_cell(row, col)
            end
        end
        love.graphics.setColor(0, 1, 1)
        self:draw_cell(self.food.y, self.food.x, self.food.scale)

        self.snake:draw()
    end

    function grid:update(dt)
        grid_timer:update(dt)
        self.snake:update(dt)
    end

    return grid
end

return grid
