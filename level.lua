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
    lvl_gravity = 700
    firefly_grav_factor = 140 
    firefly_gravity = lvl_gravity / firefly_grav_factor
    ambient_color = {0.05, 0.05, 0.1}     
    player = frogo:new(game_w / 2, game_h / 2, 21, 16, 100, 250, lvl_gravity)
    objects = {
        -- here comes only objects with draw and update methods implemented 
        drawable_updatable = {
            firefly:new(15, 15, 8, firefly_gravity),
            firefly:new(32, 32, 8, firefly_gravity),
            firefly:new(128, 128, 8, firefly_gravity),
            player
        }
    }
end 

function level_update(dt)
    for _, obj in ipairs(objects.drawable_updatable) do 
        obj:update(dt)
        -- collisions 
        if obj.__baseclass == frogo then 
            player_floor_col(obj)
        elseif obj.__baseclass == firefly then
            firefly_screen_col(obj)
        end 
    end 
end 

function level_draw() 
    love.graphics.print("jump_speed" .. player.vy, 0, 0)

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
        player:jump()
        spacebar_ticks = 0
    end 
end

function level_keypressed(key)
    if key == 'd' then 
        -- face right 
        player.dir_x = -1
    end 
    if key == 'a' then 
        -- face left 
        player.dir_x = 1
    end 
    if key == 'space' then 
        spacebar_ticks = get_ticks()
    end 
end 

-- collisions 
function player_floor_col(obj)
    local back = backgrounds[lvl]
    local floor = (game_h - back.h) - obj.oy
    local over = obj.x + obj.ox > back.x
            and obj.x - obj.ox < back.x + back.w

    if over and obj.vy >= 0 and obj.prev_y <= floor and obj.y >= floor then
        obj:floor_col(floor)
    end
end  

function firefly_screen_col(obj)
    if (obj.x + obj.ox >= game_w) or (obj.x - obj.ox <= 0) then 
        obj:screen_col()
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
