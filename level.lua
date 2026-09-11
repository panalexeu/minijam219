function level_load()
    game_state = 'level'

    objects = {
        -- here comes only objects with draw method implemented 
        drawable = {
            firefly:new(15, 15, 16),
            firefly:new(32, 32, 32),
            firefly:new(128, 128, 16),
        }
    }
end 

function level_draw() 
    for _, obj in ipairs(objects.drawable) do 
        obj:draw()
    end 
end 
