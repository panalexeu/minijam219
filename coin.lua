coin = animatable:new() 

function coin:init(x, y)
    self.x, self.y = x, y 
    self.w, self.h = 16, 16 
    self.ox, self.oy = self.w / 2, self.h / 2 
    self.rot = math.pi / 2 -- pi/2 radians or 90 degrees 
   
    --anims 
    self.img = sprites['coin']
    self.anim_speed =  {
        coin_flip = 0.33
    }
    self:set_anim('coin_flip')
end 

function coin:update(dt)
    self:animate(dt)
end 

function coin:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.img, self.quad, self.x, self.y, self.rot, 1, 1, self.ox, self.oy)
end 