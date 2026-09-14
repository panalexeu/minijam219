shop = class:new()

function shop:init(x, y)
    self.x, self.y = x, y 
    
    self.img = sprites['shop']
    self.anim_speed = {
        shop_sign = 0.25
    }
    self.anim_key, self.anim_timer, self.anim_frame = nil, nil, nil
    self:set_anim('shop_sign')
end 

function shop:update(dt)
    self:animate(dt)
end 

function shop:draw()
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.img, self.quad, self.x, self.y, 0, 1, 1, 0, 0)
end 

-- TODO maybe refactor this to animatable or smth
-- just taken from frogo for now i am lazy again 
function shop:set_anim(key)
    if self.anim_key ~= key then 
        self.anim_key = key 
        self.anim_frame = 1
        self.anim_timer = 0 
        self.quad = quads[self.anim_key][self.anim_frame]
    end  
end 

function shop:next_anim_frame() 
    self.anim_timer = 0 
    self.anim_frame = self.anim_frame + 1
    if self.anim_frame > #quads[self.anim_key] then 
        self.anim_frame = 1 
    end 
end 

function shop:animate(dt)
    self.anim_timer = self.anim_timer + dt
    if self.anim_timer >= self.anim_speed[self.anim_key] then 
        self:next_anim_frame() 
        self.quad = quads[self.anim_key][self.anim_frame]
    end 
end 