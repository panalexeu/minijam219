frogo = class:new() 

function frogo:init(x, y, w, h, jump_speed, gravity)
    self.x = x
    self.y = y
    self.w = w 
    self.h = h
    self.ox = self.w/2
    self.oy = self.h/2  
    self.jump_speed = jump_speed
    self.gravity = gravity

    -- -1 face right, 1 face left
    self.dir_x = -1  
    -- -1 up, 1 down, 0 on the ground
    self.dir_y = 0 
    self.dir_y_momentum = 0
   

    self.img = sprites['frogo']
    self.quad = quads['frogo_idle'][1]
end 

function frogo:update(dt)
    if self.dir_y == -1 then 
        -- leap jump (constant)
        self.y = self.y + (self.jump_speed * self.dir_y) 
        self.x = self.x + (self.jump_speed * -self.dir_x)
        
        -- gravity momentum
        self.dir_y_momentum = self.dir_y_momentum + self.gravity * dt
        self.y = self.y + self.dir_y_momentum
    end 

    -- basic floor collision
    if self.y >= 224-self.h then 
        self.dir_y = 0
        self.dir_y_momentum = 0
    end 

    -- basic wall collision 
    if self.x <= 0 then 
        self.x = 0
    elseif self.x >= 400-self.w then 
        self.x = 400-self.w
    end 
end 

function frogo:draw() 
    love.graphics.draw(self.img, self.quad, self.x, self.y, 0, self.dir_x, 1, self.ox, self.oy)
end 
