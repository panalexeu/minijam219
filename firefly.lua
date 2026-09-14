firefly = class:new()

function firefly:init(x, y, size, gravity)
    self.x, self.y = x, y 
    self.ox, self.oy = size / 2,  size / 2
    self.size = size 
    self.gravity = gravity 

    self.dirs = {-1, 1}
    self.dir_x = self.dirs[love.math.random(#self.dirs)]    
    self.dir_y = math.sin(self.x)
    self.velocities = {10, 15, 20, 25, 30}
    self.vx = self.velocities[love.math.random(#self.velocities)]
    self.vy = self.vx 
    self.t = self.vx -- inner clock that starts from random velocity 

    self.glow_alpha = 0.75 -- glow brightness 
    self.glow_beta = 2.7 -- blinking speed 
    self.color = {0.8, 1, 0.3, 1}
    local img_data = love.image.newImageData(size, size)
    -- eucledian distance with alpha gradually decreasing from the centre of an image
    img_data:mapPixel(function(x,y)
        local d = math.sqrt((x-size/2)^2 + (y-size/2)^2) / (size/2)
        return 1,1,1, math.max(0, 1-d)^2
    end)
    self.img = love.graphics.newImage(img_data)
end 

function firefly:draw()
    local glow = self.glow_alpha + (1 - self.glow_alpha) * math.sin(self.t * self.glow_beta)
    local glow_color = vec_m_scalar(self.color, glow)
    love.graphics.setColor(glow_color)
    love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.ox, self.oy)
end  

function firefly:update(dt)
    -- gravity
    self.y = self.y + self.gravity * dt
    -- movement 
    self.x = self.x + self.dir_x * self.vx * dt
    self.y = self.y + self.dir_y * self.vy * dt
    self.dir_y = math.sin(self.x)
    
    -- inner clock
    self.t = self.t + dt 
end 

function firefly:screen_col()
    self.dir_x = -self.dir_x
end