function level_load()
    game_state = 'level'
    
    pos, timer = 1, 0
    music_player = mplayer:new(162, moon_sonata)
    frogo = frogo:new(16, 128, 21, 16, 1.7, 4)
    objects = {
        -- here comes only objects with draw method implemented 
        drawable = {
            firefly:new(15, 15, 16),
            firefly:new(32, 32, 32),
            firefly:new(128, 128, 16),
            frogo
        }
    }
end 

function level_update(dt)
    music_player:update(dt)
    frogo:update(dt)
end 

function level_draw() 
    for _, obj in ipairs(objects.drawable) do 
        obj:draw()
    end 
end 

function level_keypressed(key)
    if key == 'd' then 
        -- face right 
        frogo.dir_x = -1
    end 
    if key == 'a' then 
        -- face left 
        frogo.dir_x = 1
    end 
    if key == 'space' then 
        frogo.dir_y = -1 
    end 
end 