function love.load() 
    require "class"
    require "level"
    require "firefly"
    require "frogo"
    require "utils"
    require "ui"
    require "score"

    game_state = "load"
    frames = 60
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
    -- sounds 
    sounds ={}
    load_sound('catch', 'catch.wav')
    load_sound('land', 'land.wav')

    -- sprites n quads 
    sprites = {
    }
    quads = {
    }
    fontquads = {
    }
    load_sprite('frogo', 'frogo.png')
    load_sprite('ui', 'ui.png')
    load_sprite('platform1', 'platform1.png') 
    load_sprite('platform2', 'platform2.png') 
    load_sprite('platform3', 'platform3.png') 
    load_sprite('font', 'font.png')
    load_quads('frogo_idle', 0, 21, 16, 4)
    load_quads('frogo_jump', 1, 21, 16, 1)
    load_quads('frogo_fall', 2, 21, 16, 1)
    load_quads('frogo_land', 3, 21, 16, 2)
    load_quads('ui_jar', 0, 16, 16, 1)
    load_quads('ui_heart', 1, 16, 16, 1)
    fontglyphs = '10'
    load_fontquads(fontglyphs, 8)

    -- shaders (for now turned off) 
    shader = love.graphics.newShader('shaders/shader.frag')
    shader = nil 

    level_load()
end 

function love.update(dt)
    if game_state == 'level' then
        level_update(dt)
    end
end

function love.draw()    
    love.graphics.setCanvas(screen)
    love.graphics.setShader(shader)

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

function load_sound(key, path)
    sounds[key] = love.audio.newSource('assets/sound/' .. path, 'static')
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

function load_fontquads(glyphs, w)
    local img = sprites['font']
    for i=1,string.len(glyphs) do 
        fontquads[string.sub(glyphs, i, i)] = love.graphics.newQuad((i-1)*w, 0, w, w, img:getWidth(), img:getHeight())
    end 
end 

function properprint(s, x, y, scale)
    local startx = x
	for i = 1, string.len(tostring(s)) do
		local char = string.sub(s, i, i)
		if char == "|" then
			x = startx-(i*8)*scale
			y = y + 10*scale
		elseif fontquads[char] then
            local x = x+((i-1)*8)*scale
			love.graphics.draw(sprites['font'], fontquads[char], x, y, 0, scale, scale)
		end
	end
end
