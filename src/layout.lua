return {
    center = function (child)
        local yx = (love.graphics.getWidth()) / 2
        local cy = (love.graphics.getHeight()) / 2

        local child_width, child_height = child.getSize()

        child:draw(yx - child_width / 2, cy - child_height / 2)
    end
}
