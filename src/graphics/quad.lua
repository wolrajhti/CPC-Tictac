local Quad = {}
Quad.mt = {__index = Quad}

local utils = require 'src.utils'

function Quad.new(texture, x, y, width, height, ox, oy)
  local new = {
    texture = texture,
    quad = love.graphics.newQuad(x, y, width, height, texture:getDimensions()),
    ox = ox or width / 2,
    oy = oy or height / 2
  }
  setmetatable(new, Quad.mt)
  return new
end

function Quad.draw(self, scale, x, y, reverse) -- reverse pas terrible
  love.graphics.draw(self.texture, self.quad, x, y, 0, utils.ternary(reverse, -1, 1) * scale, scale, self.ox, self.oy)
end

function Quad.copy(self)
  local x, y, w, h = self.quad:getViewport()
  return self.new(self.texture, x, y, w, h, self.ox, self.oy)
end

return Quad