score = class:new()

function score:init(n,x,y,gravity)
    self.n = n 
    self.s = tostring(self.n)
    self.x, self.y = x, y
    self.gravity = gravity
    self.t = 0 
    self.lifetime = 3 
    self.scale = 0.5
end

function score:draw() 
    properprint(self.s, self.x, self.y, self.scale)
end 

function score:update(dt)
    self.t = self.t + dt 
    self.y = self.y - self.gravity * dt 
end 

