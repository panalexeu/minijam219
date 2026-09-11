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
    game_screen = love.graphics.newCanvas(game_w, game_h)

    -- music 
    notes = {}
    for i = 0, 7 do
        notes[i+1] = love.audio.newSource("assets/sound/note" .. i .. ".wav", "static")
    end

    -- sprites n quads 
    sprites = {
    }
    quads = {
    }
    load_sprite('frogo', 'frogo.png')
    load_quads('frogo_idle', 0, 21, 16, 4)
    load_quads('frogo_jump', 1, 21, 16, 1)
    load_quads('frogo_fall', 2, 21, 16, 1)

    level_load()
end 

function love.update(dt)
    if game_state == 'level' then
        level_update(dt)
    end
end

function love.draw()     
    if game_state == 'level' then 
        level_draw()
    end 
end 

function love.keypressed(key)
    if game_state == 'level' then 
        level_keypressed(key)
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