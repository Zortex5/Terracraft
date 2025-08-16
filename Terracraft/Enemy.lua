local love = require 'love'

function Enemy(Level)
    local l = Level
    if l == 0 then
        l = 1
    end
    local place = 2001 - math.random(4001)
    
    return {
        level = l,
        radius = 5 * l,
        x = place,
        y = -400,

        move = function(self, player_x, player_y)
            if player_x + 20 > self.x then
                self.x = self.x + self.level
            elseif player_x + 20 < self.x then
                self.x = self.x - self.level
            end

            if player_y + 40 > self.y then
                self.y = self.y + self.level
            elseif player_y + 40 < self.y then
                self.y = self.y - self.level
            end
        end,

        draw = function(self)
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle("fill", self.x, self.y, self.radius)
        end
    }
end

return Enemy