animatable = class:new() 

function animatable:init() 
    self.img = nil
    self.anim_speed = {
    }
    self.anim_key, self.anim_timer, self.anim_frame = nil, nil, nil
end 

function animatable:set_anim(key)
    if self.anim_key ~= key then 
        self.anim_key = key 
        self.anim_frame = 1
        self.anim_timer = 0 
        self.quad = quads[self.anim_key][self.anim_frame]
    end  
end 

function animatable:next_anim_frame() 
    self.anim_timer = 0 
    self.anim_frame = self.anim_frame + 1
    if self.anim_frame > #quads[self.anim_key] then 
        self.anim_frame = 1 
    end 
end 

function animatable:animate(dt)
    self.anim_timer = self.anim_timer + dt
    if self.anim_timer >= self.anim_speed[self.anim_key] then 
        self:next_anim_frame() 
        self.quad = quads[self.anim_key][self.anim_frame]
    end 
end 
