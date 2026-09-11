function level_load()
    game_state = 'level'   
    spacebar_ticks = 0
    music_player = mplayer:new(120, moon_sonata)
    frogo = frogo:new(16, 128, 21, 16, 1, 3.5)
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

function level_keyreleased(key)
    if key == 'space' then 
        local ticks_passed = get_ticks() - spacebar_ticks
        frogo.jump_speed = ticks2jmp_speed(ticks_passed)
        frogo.dir_y = -1 
        spacebar_ticks = 0
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
        spacebar_ticks = get_ticks()
        print(spacebar_ticks)
    end 
end 

function get_ticks()
    return math.floor(love.timer.getTime() * 1000)
end 

function ticks2jmp_speed(ticks)
    -- play with this 
    if ticks <= 1000 then 
        return 1.0 
    elseif ticks >= 3000 then
        return 3.0
    else 
        return ticks / 1000 
    end 
end 
