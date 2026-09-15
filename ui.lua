ui = class:new()

function ui:init(x, y, hearts)
    self.x, self.y = x, y 
    self.hearts = hearts 
    self.score = 0

    self.w = 16 
    self.img = sprites['ui']
end 

function ui:draw()
    love.graphics.setColor(1,1,1,1)

    -- hearts 
    for i=1,self.hearts do 
        love.graphics.draw(self.img, quads['ui_heart'][1], (i-1) * self.w / 2, self.y, 0, 1, 1)
    end 
end 

function ui:next_score() 
    self.score = self.score + 1
end

function ui:update(dt)
    --placeholder 
end 