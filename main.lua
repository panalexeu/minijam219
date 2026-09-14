function love.load() 
    require "class"
    require "level"
    require "firefly"
    require "mplayer"
    require "tracks"
    require "frogo"
    require "utils"

    game_state = "load"
    game_w, game_h  = 400, 224 
    window_w, window_h = 800, 448
    love.window.setMode(window_w, window_h)
    screen = love.graphics.newCanvas(game_w, game_h)
    -- sreen to window scaling that fits game with offsets: 
    screen_scale = math.min(window_w / game_w, window_h / game_h)
    screen_offset_x = math.floor((window_w - game_w * screen_scale) / 2)
    screen_offset_y = math.floor((window_h - game_h * screen_scale) / 2)
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- music 
    notes = {}
    for i = 0, 7 do
        notes[i+1] = love.audio.newSource('assets/sound/note' .. i .. '.wav', 'static')
    end

    -- sprites n quads 
    sprites = {
    }
    quads = {
    }
    load_sprite('frogo', 'frogo.png')
    load_sprite('back1', 'back1.png') 
    load_sprite('back2', 'back2.png') 
    load_sprite('back3', 'back3.png') 
    load_quads('frogo_idle', 0, 21, 16, 4)
    load_quads('frogo_jump', 1, 21, 16, 1)
    load_quads('frogo_fall', 2, 21, 16, 1)
    load_quads('frogo_land', 3, 21, 16, 2)

    level_load()
end 

function love.update(dt)
    if game_state == 'level' then
        level_update(dt)
    end
end

function love.draw()    
    love.graphics.setCanvas(screen)
    
    if game_state == 'level' then 
        level_draw()
    end 

    love.graphics.setCanvas()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(screen, screen_offset_x, screen_offset_y, 0, screen_scale, screen_scale)
end 

function love.keypressed(key)
    if game_state == 'level' then 
        level_keypressed(key)
    end 

    if key == 'escape' then
        love.event.quit(0)
    end
end

function love.keyreleased(key)
    if game_state == 'level' then 
        level_keyreleased(key)
    end 
end

function load_sprite(key, path) 
    sprites[key] = love.graphics.newImage('assets/' .. path)
end 

function load_quads(key, y_offset, w, h, frames)
    local prfx = split(key, '_')[1]
    local img = sprites[prfx]
    local t = {}
    for i=0,frames-1 do
        local quad = love.graphics.newQuad(i*w, y_offset*h, w, h, img:getWidth(), img:getHeight()) 
        table.insert(t, quad)
    end     
    quads[key] = t
end  