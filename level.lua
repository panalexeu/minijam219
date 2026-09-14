function level_load()
    game_state = 'level'   
    spacebar_ticks = 0
    lvl = 3
    lvl_gravity = 700
    firefly_grav_factor = 140 
    firefly_gravity = lvl_gravity / firefly_grav_factor   

    -- objects 
    player = frogo:new(game_w / 2, game_h / 2, 21, 16, 100, 250, lvl_gravity)
    fireflies = {
        firefly:new(15, 15, 8, firefly_gravity),
        firefly:new(15, 15, 8, firefly_gravity),
        firefly:new(15, 15, 8, firefly_gravity),
        firefly:new(32, 32, 8, firefly_gravity),
        firefly:new(112, game_h-48, 16, firefly_gravity)
    }
    lightable = fireflies
    updatable = vec_cat(fireflies, {player}) 

    -- rudimentary lighting system 
    platforms = {
        {
            sprite = sprites['platform1'], 
            x = 176,
            w = 48,
            h = 48,
        },
        {
            sprite = sprites['platform2'], 
            x = 144,
            w = 112,
            h = 48,
        },
        {
            sprite = sprites['platform3'], 
            x = 112,
            w = 176,
            h = 48,
        }
    } 
    -- claude suggested these colors 
    ambient_color = {0.62, 0.66, 0.80, 1}   -- pale periwinkle / moonlit lavender-blue
    back_color    = {0.42, 0.45, 0.58, 1}   -- dusty slate blue
    light_canvas = love.graphics.newCanvas(game_w, game_h)
end 

function level_update(dt)
    for _, obj in ipairs(updatable) do 
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
    -- draw light_canvas
    love.graphics.setCanvas(light_canvas) 
    love.graphics.clear(ambient_color)
    love.graphics.setBlendMode("add")
    draw_light(16)
    for _, obj in ipairs(lightable) do 
        obj:draw()
    end
    love.graphics.setBlendMode("alpha")

    -- draw everything on level that does not emit light  
    love.graphics.setCanvas(screen)
    draw_back()
    player:draw()

    -- multiply the light_canvas with the level
    love.graphics.setBlendMode("multiply", "premultiplied") 
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(light_canvas)
    love.graphics.setBlendMode("alpha")
end 

-- draw 
function draw_back() 
    love.graphics.clear(back_color)
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(platforms[lvl].sprite, 0, 0, 0, 1, 1)
end 

function draw_light(w)
    love.graphics.setColor(1,1,1,1)
    local ox = w / 2 
    local x = (game_w / 2) - ox
    love.graphics.rectangle('fill', x, 0, w, game_h, 0, 0)
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
    local platform = platforms[lvl]
    local floor = (game_h - platform.h) - obj.oy
    local over = obj.x + obj.ox > platform.x
            and obj.x - obj.ox < platform.x + platform.w

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
