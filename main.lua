function love.load() 
    require "class"

    require "level"
    require "firefly"
    require "mplayer"
    require "tracks"

    game_state = "load"

    love.window.setMode(800, 448)

    notes = {}
    for i = 0, 7 do
        notes[i+1] = love.audio.newSource("assets/sound/note" .. i .. ".wav", "static")
    end

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
