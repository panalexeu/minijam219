function level_load()
    game_state = 'level'   
    spacebar_ticks = 0
    lvl = 1
    cur_score = 0 
    lvl_gravity = 700
    firefly_grav_factor = 100
    firefly_gravity = lvl_gravity / firefly_grav_factor
    score_grav_factor = 100
    score_gravity = lvl_gravity / score_grav_factor 
    -- fireflies lifezones {x1, x2, y1, y2}
    lz_offset = 32
    lifezones = {
        left = {x1 = 0, x2 = (game_w / 2) - lz_offset, y1 = nil, y2 = nil},
        right = {x1 = (game_w / 2) + lz_offset, x2 = game_w, y1 = nil, y2 = nil}
    }
    -- backgrounds
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

    -- objects 
    spawn_x, spawn_y = game_w / 2, 0
    player = frogo:new(spawn_x, spawn_y, 21, 16, 100, 250, lvl_gravity)
    ui = ui:new(0, 0, 3, 0)
    shop_x, shop_y = shop_loc(16)
    vending_machine = shop:new(shop_x, shop_y)
    fireflies = vec_cat(spawn_fireflies(10, 10, 5, 5, 20, lifezones.left), spawn_fireflies(390, 10, 5, 5, 20, lifezones.right))
    objects = vec_cat(fireflies, {vending_machine, player}) 

    -- rudimentary lighting system 
    -- claude suggested these colors 
    ambient_color = {0.62, 0.66, 0.80, 1}   -- pale periwinkle / moonlit lavender-blue
    --back_color    = {0.42, 0.45, 0.58, 1}   -- dusty slate blue
    back_color = {0,0,0,1}
    light_canvas = love.graphics.newCanvas(game_w, game_h)
    canvas_mode = false
end 

function level_update(dt)
    for i, obj in ipairs(objects) do 
        obj:update(dt)
        -- collisions 
        if obj.__baseclass == frogo then 
            player_floor_col(obj)
            player_fall_col(obj)
        elseif obj.__baseclass == firefly then
            firefly_lz_col(obj)
            firefly_player_col(i, obj, player)
        elseif obj.__baseclass == score then 
            score_cleanup(i, obj)
        elseif obj.__baseclass == shop then 
            shop_player_col(obj, player)
        end 
    end 
end 

function level_draw() 
    -- rudimentary lighting system 
    if canvas_mode then 
        -- draw light_canvas
        love.graphics.setCanvas(light_canvas) 
        love.graphics.clear(ambient_color)
        love.graphics.setBlendMode("add")
        draw_light(16)
        for _, obj in ipairs(objects) do 
            if obj.__baseclass == firefly then
                obj:draw()
            end
        end
        love.graphics.setBlendMode("alpha")
        
        -- draw everything on level that does not emit light  
        love.graphics.setCanvas(screen)
        draw_back()
        for _, obj in ipairs(objects) do 
            if obj.__baseclass ~= firefly then
                obj:draw()
            end
        end

        -- multiply the light_canvas with the level
        love.graphics.setBlendMode("multiply", "premultiplied") 
        love.graphics.setColor(1,1,1,1)
        love.graphics.draw(light_canvas)
        love.graphics.setBlendMode("alpha")
    -- no lighting and it seems to be better
    else 
        draw_back()
        for _, obj in ipairs(objects) do 
            obj:draw()
        end 
    end

    -- ui 
    ui:draw()
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
    if key == 'e' and vending_machine.is_active then 
        -- TODO continue from here tomorrow 
        print('player opened shop')
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

function player_fall_col(obj)
    if (obj.y - obj.oy) >= game_h then 
        player_respawn()
    end 
end 

function firefly_lz_col(obj)
    if (obj.x - obj.ox <= obj.lz.x1)  or (obj.x + obj.ox >= obj.lz.x2) then 
        obj:lz_col()
    end 
end 

function obj_overlap(obj, player)
    -- AABB overlap (axis-aligned bounding box)
    return math.abs(obj.x - player.x) < obj.ox + player.ox 
           and math.abs(obj.y - player.y) < obj.oy + player.oy
end 

function firefly_player_col(i, obj, player) 
    if obj_overlap(obj, player) then
        -- catch firefly 
        -- :clone so plays multiple times every time catch happened 
        sounds['catch']:clone():play()  
        table.remove(objects, i)
        -- update score
        local n = 1000
        cur_score = cur_score + n
        local s = score:new(n, player.x, player.y, score_gravity)
        table.insert(objects, s)
    end
end

function shop_player_col(obj, player)
    if obj_overlap(obj, player) then 
        obj.is_active = true 
    else 
        obj.is_active = false
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

-- stuff 
function spawn_fireflies(x, y, dx, dy, count, lifezone)
    -- spawn a cluster of fireflies around x,y with deviation [-x,x],[-y,y]
    local t = {}
    for i=1,count do
        local ox = love.math.random(-dx, dx)
        local oy = love.math.random(-dy, dy)
        local fly = firefly:new(x+ox, y+oy, 8, firefly_gravity, lifezone)
        table.insert(t, fly)
    end 
    return t
end 

function score_cleanup(i, obj)
    if obj.t >= obj.lifetime then 
        table.remove(objects, i)
    end 
end 

function player_respawn() 
    player.x, player.y = spawn_x, spawn_y 
    player.vx, player.vy = 0, 0
    ui.hearts = ui.hearts - 1
end 

function shop_loc(oy)
    local platform = platforms[lvl]
    local x = game_w / 2
    local y = game_h - platform.h - oy
    return x, y 
end