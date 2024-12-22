local animations = require "animations"

local snake = {}

function snake.newSnake(x, y, speed, maxSpeed, speedStep, grid)
    local snake = {
        grid = grid,
        speed = speed,
        max_speed = maxSpeed,
        speed_step = speedStep,
        direction = nil,
        next_direction = nil,
        segments = {
            {x = x, y = y, scale = 1},
        },
        eat_timer = Timer.new()
    }

    local speed_timer = snake.speed_step

    local function move()
        local head = snake.segments[1]
        local new_head = {
            x = head.x,
            y = head.y,
            scale = 1,
        }

        if snake.direction == "up" then
            new_head.y = (new_head.y - 1) % (grid.cell_count)
        elseif snake.direction == "down" then
            new_head.y = (new_head.y + 1) % (grid.cell_count)
        elseif snake.direction == "left" then
            new_head.x = (new_head.x - 1) % (grid.cell_count)
        elseif snake.direction == "right" then
            new_head.x = (new_head.x + 1) % (grid.cell_count)
        end

        table.insert(snake.segments, 1, new_head)
        return table.remove(snake.segments)
    end

    local function handle_input()
        if love.keyboard.isDown("up") and (#snake.segments == 1 or snake.direction ~= "down") then
            snake.next_direction = "up"
        elseif love.keyboard.isDown("down") and (#snake.segments == 1 or snake.direction ~= "up") then
            snake.next_direction = "down"
        elseif love.keyboard.isDown("left") and (#snake.segments == 1 or snake.direction ~= "right") then
            snake.next_direction = "left"
        elseif love.keyboard.isDown("right") and (#snake.segments == 1 or snake.direction ~= "left") then
            snake.next_direction = "right"
        end
    end

    local function check_head_collision()
        local head = snake.segments[1]
        for i = 2, #snake.segments do
            if head.x == snake.segments[i].x and head.y == snake.segments[i].y then
                return true
            end
        end
        return false
    end

    local function swallow_effect()
        for i, segment in ipairs(snake.segments) do
            snake.eat_timer:after(0.025 * (i-1), function()
                animations.pulse(snake.eat_timer, segment, "scale", 1.15, 0.1, 0.05)
            end)
        end
    end

    function snake:draw()
        love.graphics.setColor(1, 0, 1)
        for _, segment in ipairs(self.segments) do
            grid:draw_cell(segment.y, segment.x, segment.scale)
            love.graphics.setColor(0.8, 0, 0.8)
        end
    end

    function snake:update(dt)
        self.eat_timer:update(dt)
        handle_input()
        if snake.next_direction or snake.direction then
            speed_timer = speed_timer + dt
            if speed_timer >= snake.speed then
                speed_timer = 0
                snake.direction = snake.next_direction or snake.direction
                local last_segment = move()
                if grid:check_food_collision() then
                    table.insert(snake.segments, last_segment)
                    snake.speed = math.max(snake.speed - snake.speed_step, snake.max_speed)
                    swallow_effect()
                    Signal.emit("eat")
                    if #self.segments == grid.cell_count * grid.cell_count then
                        Signal.emit("win")
                    else
                        grid:reset_food()
                    end
                elseif check_head_collision() then
                    table.insert(snake.segments, last_segment)
                    Signal.emit("die")
                end
            end
        end
    end

    return snake
end

return snake
