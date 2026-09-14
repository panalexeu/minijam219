score = class:new()

function score:init(n,x,y,gravity)
    self.n = n 
    self.s = tostring(self.n)
    self.x, self.y = x, y
    self.gravity = gravity
    self.t = 0 
    self.lifetime = frames * 3 
    self.scale = 0.5
end

function score:draw() 
    if self.t <= self.lifetime then
        properprint(self.s, self.x, self.y, self.scale)
    end  
end 

function score:update(dt)
    self.t = self.t + dt 
    self.y = self.y - self.gravity * dt 
end 

