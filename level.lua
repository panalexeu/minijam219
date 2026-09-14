function level_load()
    game_state = 'level'   
    spacebar_ticks = 0
    backgrounds = {
        {
            sprite = sprites['back1'], 
            x = 176,
            w = 48,
            h = 48,
        },
        {
            sprite = sprites['back2'], 
            x = 144,
            w = 112,
            h = 48,
        },
        {
            sprite = sprites['back3'], 
            x = 112,
            w = 176,
            h = 48,
        }
    } 
    lvl = 3
    ambient_color = {0.05, 0.05, 0.1}     
    frogo = frogo:new(game_w / 2, game_h / 2, 21, 16, 100, 250, 700)
    objects = {
        -- here comes only objects with draw and update methods implemented 
        drawable_updatable = {
            firefly:new(15, 15, 8),
            firefly:new(32, 32, 8),
            firefly:new(128, 128, 8),
            frogo
        }
    }
end 

function level_update(dt)
    for _, obj in ipairs(objects.drawable_updatable) do 
        obj:update(dt)
    end 

    frogo_floor_col()

    -- charge the frogo jump speed 
    if love.keyboard.isDown('space') then
        local ticks_passed = get_ticks() - spacebar_ticks
        -- frogo.vy = ticks2jmp_speed(ticks_passed) 
    end
end 

function level_draw() 
    love.graphics.print("jump_speed" .. frogo.vy, 0, 0)

    -- background
    love.graphics.clear(ambient_color)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(backgrounds[lvl].sprite, 0, 0, 0, 1, 1)

    for _, obj in ipairs(objects.drawable_updatable) do 
        obj:draw()
    end 
end 

-- controls 
function level_keyreleased(key)
    if key == 'space' then 
        frogo:jump()
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
    end 
end 

-- collisions 
function frogo_floor_col()
    local back = backgrounds[lvl]
    local floor = (game_h - back.h) - frogo.oy
    local over = frogo.x + frogo.ox > back.x
            and frogo.x - frogo.ox < back.x + back.w

    if over and frogo.vy >= 0 and frogo.prev_y <= floor and frogo.y >= floor then
        frogo:floor_collide(floor)
    end
end  

-- ticks 
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
