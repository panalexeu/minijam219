frogo = class:new() 

function frogo:init(x, y, w, h, speed_y, speed_x, gravity)
    self.x = x
    self.y = y
    self.w = w 
    self.h = h
    self.ox = self.w/2
    self.oy = self.h/2  
    self.speed_x = speed_x
    self.speed_y = speed_y  
    self.gravity = gravity

    -- -1 face right, 1 face left
    self.dir_x = -1  
    self.dir_x_momentum = self.speed_x
    -- -1 up, 1 down, 0 on the ground
    self.dir_y = 0 
    self.dir_y_momentum = 0
   

    self.img = sprites['frogo']
    self.quad = quads['frogo_idle'][1]
end 

-- TODO REWROK PHYSICS WITH CLAUDE
function frogo:update(dt)
    if self.dir_y == -1 then 
        -- leap jump (constant)
        self.y = self.y + (self.speed_y * self.dir_y) 
        self.x = self.x + (self.dir_x_momentum * -self.dir_x)
        
        -- momentums 
        self.dir_y_momentum = self.dir_y_momentum + self.gravity * dt

        -- two physical powers influnce frogo: air friciton/gravity 
        -- gravity
        self.y = self.y + self.dir_y_momentum
        -- air friction 
        self.dir_x_momentum = math.max(0, self.dir_x_momentum - self.speed_x * dt / 2)
    end 

    -- basic floor collision
    if self.y >= 224-self.h then 
        self.dir_y = 0
        self.dir_y_momentum = 0
        self.dir_x_momentum = self.speed_x
    end 

    -- basic wall collision 
    if self.x <= 0 then 
        self.x = 0
        self.dir_x_momentum = 0
    elseif self.x >= 400-self.w then 
        self.x = 400-self.w
        self.dir_x_momentum = 0
    end 
end 

function frogo:draw() 
    love.graphics.setColor(1,1,1,1)
    love.graphics.draw(self.img, self.quad, self.x, self.y, 0, self.dir_x, 1, self.ox, self.oy)
end 
