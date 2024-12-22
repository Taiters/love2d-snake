return {
    pulse = function(timer, subject, field, target, grow_time, shrink_time)
        timer:tween(grow_time, subject, {[field]=target}, 'out-cubic', function ()
            timer:tween(shrink_time, subject, {[field]=1}, 'out-cubic')
        end)
    end
}
