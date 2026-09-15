frogo = animatable:new() 

function frogo:init(
    x, y, 
    w, h, 
    jump_vx, jump_vy, 
    gravity
)
    self.x, self.y = x, y
    self.prev_y = self.y
    self.w, self.h = w, h 
    self.ox, self.oy = self.w/2, self.h/2  
    self.jump_vx, self.jump_vy = jump_vx, jump_vy
    self.vx, self.vy = 0, 0 
    self.gravity = gravity
    self.on_ground = false 

    -- dir_x: -1 face right, 1 face left, dir_y: -1 up, 0 on the ground
    self.dir_x = -1  

    -- anims 
    self.img = sprites['frogo']
    self.anim_speed = {
        frogo_idle = 0.5,
        frogo_land = 0.5, 
        frogo_jump = 1, 
        frogo_fall = 1
    }
    self:set_anim('frogo_idle')
end 


function frogo:jump()
    if self.on_ground then 
        self.vx = self.jump_vx
        self.vy = -self.jump_vy
        self.on_ground = false
    end 
end

function frogo:floor_col(y) 
    self.y = y
    self.vx, self.vy = 0, 0
    self.on_ground = true
end 

function frogo:update(dt)
    -- previous y pos for collision detection
    self.prev_y = self.y 

    -- gravity 
    if not self.on_ground then 
        self.vy =  self.vy + self.gravity * dt 
    end 
    -- leap
    self.x = self.x + -self.dir_x * self.vx * dt
    self.y = self.y + self.vy * dt 

    -- anim states
    if self.on_ground then 
        self:set_anim('frogo_idle')
    elseif not self.on_ground and self.vy <= 0 then 
        self:set_anim('frogo_jump')
    elseif not self.on_ground and self.vy >= 0 then 
        self:set_anim('frogo_fall')
    end 

    self:animate(dt)
end 

function frogo:draw() 
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.img, self.quad, self.x, self.y, 0, self.dir_x, 1, self.ox, self.oy)
end 
