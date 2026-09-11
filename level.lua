function level_load()
    game_state = 'level'
    
    pos, timer = 1, 0
    music_player = mplayer:new(162, moon_sonata)
    objects = {
        -- here comes only objects with draw method implemented 
        drawable = {
            firefly:new(15, 15, 16),
            firefly:new(32, 32, 32),
            firefly:new(128, 128, 16),
            frogo:new(16, 16, 21, 16)
        }
    }
end 

function level_update(dt)
    music_player:update(dt)
end 

function level_draw() 
    for _, obj in ipairs(objects.drawable) do 
        obj:draw()
    end 
end 
