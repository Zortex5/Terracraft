local love = require 'love'

function Button(text, func, function_parameters, width, height)
    return {
        width = width,
        height = height,
        func = func or function() print("Useless button") end,
        function_parameters = function_parameters,
        text = text,
        button_x = 0, button_y = 0, text_x = 0, text_y = 0,

        checkButton = function(self, mouse_x, mouse_y, cursor_radius)
            if mouse_x + cursor_radius >= self.button_x and mouse_x - cursor_radius <= self.button_x + self.width then
                if mouse_y + cursor_radius >= self.button_y and mouse_y - cursor_radius <= self.button_y + self.height then
                    if self.function_parameters then
                        self.func(self.function_parameters)
                    else
                        self.func()
                    end
                end
            end
        end,

        draw = function(self, button_x, button_y, text_x, text_y)
            self.button_x = button_x
            self.button_y = button_y
    
            if text_x then
                self.text_x = text_x + self.button_x
            else
                self.text_x = self.button_x
            end
    
            if text_y then
                self.text_y = text_y + self.button_y
            else
                self.text_y = self.button_y
            end
    
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("fill", self.button_x, self.button_y, self.width, self.height)
            love.graphics.setColor(0, 0, 0)
            love.graphics.print(self.text, love.graphics.newFont(40), self.text_x, self.text_y)
        end
    }
end

return Button