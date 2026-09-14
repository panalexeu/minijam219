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

    -- jar 
    love.graphics.draw(self.img, quads['ui_jar'][1], self.x, self.y, 0, 1, 1)
    local offset = self.score / 10 < 1 and -4 or 0
    love.graphics.print(self.score, 0, 0, 0, 1, 1, offset, 0)

    -- hearts 
    for i=1,self.hearts do 
        love.graphics.draw(self.img, quads['ui_heart'][1], i * self.w, self.y, 0, 1, 1)
    end 
end 

function ui:next_score() 
    self.score = self.score + 1
end