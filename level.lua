function level_load()
    game_state = 'level'   
    lvl = 1
    cur_score = 10000
    small_blind = 1000 
    big_blind = small_blind * 2
    cur_blind = 0
    -- physics 
    jump_vx, jump_vy = 100, 250
    lvl_gravity = 750
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
    lz_spawn = {left = {x = 10, y = 10}, right = {x = 390, y = 10}}
    -- waves 
    wave =  0
    wave_colors = {
        {1, 1, 1, 1},        -- white
        {0.3, 0.9, 0.4, 1},  -- green
        {0.9, 0.25, 0.3, 1}, -- red
        {1, 0.85, 0.3, 1},   -- yellow
        {0.65, 0.4, 0.9, 1}, -- purple
    }
    t_wave = 0 
    t_break = 0 
    firefly_count = 10
    wave_dur = 25 -- secs 
    wave_break = 5 -- secs
    is_break = true
    wave_dirs = {'left', 'right'}
    wave_dir = next_wave_dir()
    platforms = {
        {
            sprite = sprites['platform1'], 
            -- platform colision offsets
            x = 176,
            w = 48,
            h = 48,
        }
    } 
    -- items params 

    -- objects 
    spawn_x, spawn_y = game_w / 2, 0
    player = frogo:new(spawn_x, spawn_y, 21, 16, jump_vx, jump_vy, lvl_gravity)
    coin = coin:new(game_w / 2, game_h / 2) 
    active_items = {}
    menu = menu:new(0, 0, game_w, game_h, items)
    ui = ui:new(0, 0, 3, 0)
    shop_x, shop_y = shop_loc(16)
    vending_machine = shop:new(shop_x, shop_y)
    other_objects = {vending_machine, player, ui, menu} 
    objects = other_objects

    -- rudimentary lighting system 
    -- claude suggested these colors 
    ambient_color = {0.62, 0.66, 0.80, 1}   -- pale periwinkle / moonlit lavender-blue
    --back_color    = {0.42, 0.45, 0.58, 1}   -- dusty slate blue
    back_color = {0,0,0,1}
    light_canvas = love.graphics.newCanvas(game_w, game_h)
    canvas_mode = false
end 

function level_update(dt)
    -- timers 
    if is_break then 
        t_break = t_break + dt
    else
        t_wave = t_wave + dt 
    end
    
    -- wave finished: break starts 
    if t_wave >= wave_dur then 
        t_wave = 0
        is_break = true
        items_effects_cleanup()
        clear_items()
        clear_fireflies()
        update_score()
        wave_dir = next_wave_dir()
    -- break finished: wave starts  
    elseif t_break >= wave_break then 
        t_break = 0 
        is_break = false 
        menu.is_active = false
        wave_start()
        cur_blind = get_blind()
        -- note: items are notified after batch of fireflies is created
        notify_items()
    end 

    -- objects updates
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

    check_gameover()
end 

-- draw 
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
        draw_active_items()
        draw_info()
    end
end 

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

function draw_active_items()
    love.graphics.setColor(1,1,1,1)
    local y = game_h - 16
    local offset = 8
    for i,item in ipairs(active_items) do 
        love.graphics.draw(item.img, item.quad, (i-1) * offset, y, 0, 1, 1)
    end 
end 

function draw_info() 
    local color_num = math.floor((wave / 10) + 1) 
    love.graphics.setColor(wave_colors[color_num])
    local s = "wave*" .. wave .. " " .. "blind*" .. cur_blind .. " " .. "score*" .. cur_score .. " " .. "break*" .. tostring(is_break)
    properprint(s, 0, game_h - 8, 1)
end 

-- controls 
function level_keyreleased(key)
    if key == 'space' then 
        player:jump()
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
    if key == 'e' and vending_machine.is_active and is_break then 
        menu.is_active = not menu.is_active
    end 

    -- menu controls 
    if key == 'up' and vending_machine.is_active then menu:decr_idx() end
    if key == 'down' and vending_machine.is_active then menu:incr_idx() end
    if key == 'return' and vending_machine.is_active then buy_item(menu:get_cur_item()) end 
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
        cur_score = cur_score + obj.score
        local s = score:new(obj.score, player.x, player.y, score_gravity)
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

-- wave logic and stuff
function clear_fireflies()
    for i, obj in ipairs(objects) do
        if obj.__baseclass == firefly then  
            table.remove(objects, i)
        end
    end
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

function wave_start()
    wave = wave + 1
    local count = firefly_count * wave
    fireflies = spawn_fireflies(lz_spawn[wave_dir].x, lz_spawn[wave_dir].y, 5, 5, count, lifezones[wave_dir])
    objects = vec_cat(fireflies, other_objects)
end 

function next_wave_dir()
    return wave_dirs[love.math.random(#wave_dirs)]
end 

function get_blind()
    local temp = nil
    if wave % 2 == 1 then 
        temp = small_blind 
    else 
        temp = big_blind
    end
    return temp * wave
end 

function update_score()
    cur_score = cur_score - cur_blind
end 

function check_gameover() 
    if ui.hearts == 0 or cur_score < 0 then game_state = 'gameover' end 
end 

function buy_item(item)
    cur_score = cur_score - item.price
    table.insert(active_items, item)
end 

-- item handlers 
function notify_items()
    for i,item in ipairs(active_items) do 
        if item.name == 'heart' then handle_heart() end 
        if item.name == 'eye' then handle_eye() end 
        if item.name == 'mult' then handle_mult() end 
        if item.name == 'jump' then handle_jump() end 
        if item.name == 'gravity' then handle_gravity() end 
        if item.name == 'equal' then handle_equal() end 
    end 
end

function clear_items()
    active_items = {}
end 

function handle_heart() 
    -- increase lives 
    ui.hearts = ui.hearts + 1 
end

function handle_eye()
end 

function handle_mult()
    -- just spaw fireflies again x2 times 
    local count = firefly_count * wave
    fireflies = spawn_fireflies(lz_spawn[wave_dir].x, lz_spawn[wave_dir].y, 5, 5, count, lifezones[wave_dir])
    objects = vec_cat(fireflies, objects)
end 

function handle_jump()
    player.jump_vx = jump_vx * 1.5
    player.jump_vy = jump_vy * 1.5
end 

function handle_gravity() 
    player.gravity = lvl_gravity * 0.5
end 

function handle_equal() 
end 

function items_effects_cleanup()
    player.jump_vx = jump_vx
    player.jump_vy = jump_vy
    player.gravity = lvl_gravity
end 