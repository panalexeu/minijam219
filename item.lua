item = class:new() 

function item:init(name, description, price, icon)
    self.name = name 
    self.description = description 
    self.price = price 
    self.icon = icon 
    self.img = sprites['icons']
    self.quad = quads[self.icon][1]
end 
