menu = class:new()

function menu:init(x, y, w, h, items) 
    self.x, self.y = x, y 
    self.w, self.h = w, h
    self.items = items  
    self.is_active = false 
    self.item_offset = 16
    self.item_scale = 2
    self.menu_color = {0.22, 0.24, 0.40, 1}
end 

function menu:update(dt)
end 

function menu:draw()
    if self.is_active then
        love.graphics.setColor(self.menu_color)
        local x_rect, y_rect = self.x, self.y
        love.graphics.rectangle('fill', x_rect, y_rect, self.w, self.h)

        -- draw menu items 
        love.graphics.setColor(1,1,1,1)
        for i,item in ipairs(items) do 
            local x, y = x_rect + self.item_offset / 4, y_rect + (i-1) * self.item_offset
            love.graphics.draw(item.img, item.quad, x, y, 0, self.item_scale, self.item_scale, 0, 0)
            local s = item.description .. ' x ' .. item.price
            properprint(s, x + self.item_offset, y + self.item_offset / 4, 1.0)
        end 
    end 
end 