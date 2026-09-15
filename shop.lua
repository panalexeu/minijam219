shop = animatable:new()

function shop:init(x, y)
    self.x, self.y = x, y 
    self.w, self.h = 16, 32
    self.ox, self.oy = self.w/2, self.h/2
    self.is_active = false
    self.active_offset = 2 
    
    self.hotkey_img = sprites['hotkeys']
    self.hotkey_e = quads['hotkeys_e'][1]

    -- anims 
    self.img = sprites['shop']
    self.anim_speed = {
        shop_sign = 0.25
    }
    self:set_anim('shop_sign')
end 

function shop:update(dt)
    self:animate(dt)
end 

function shop:draw()
    love.graphics.setColor(1,1,1,1)
    if self.is_active then 
        -- draw white outline: works do not touch!
        love.graphics.rectangle('fill', self.x - self.ox - self.active_offset / 2, self.y - self.oy - self.active_offset / 2, self.w + self.active_offset, self.h)
        -- draw hotkey icon 
        love.graphics.draw(self.hotkey_img, self.hotkey_e, self.x, self.y - self.oy * 1.5, 0, 1, 1, self.ox, self.oy)
    end
    love.graphics.draw(self.img, self.quad, self.x, self.y, 0, 1, 1, self.ox, self.oy)
end 