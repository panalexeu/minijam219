ui = class:new()

function ui:init(x, y, hearts, score)
    self.x, self.y = x, y 
    self.hearts = hearts 
    self.score = score 

    self.w = 16 
    self.img = sprites['ui']
end 

function ui:draw()
    love.graphics.setColor(1,1,1,1)

    -- jar 
    love.graphics.draw(self.img, quads['ui_jar'][1], self.x, self.y, 0, 1, 1)

    -- hearts 
    for i=1,self.hearts do 
        love.graphics.draw(self.img, quads['ui_heart'][1], i * self.w, self.y, 0, 1, 1)
    end 
end 