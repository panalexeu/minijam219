function love.load() 
    require "class"

    require "level"
    require "firefly"

    game_state = "load"

    love.window.setMode(800, 448)

    level_load()
end 

function love.draw()     
    if game_state == 'level' then 
        level_draw()
    end 
end 

