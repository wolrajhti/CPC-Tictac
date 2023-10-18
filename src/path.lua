local Path = {}
Path.mt = {__index = Path}

local utils = require 'src.utils'

function Path.new(x1, y1, x2, y2)
  local new = {
    x1 = x1, y1 = y1,
    x2 = x2, y2 = y2,
    t = 0,
    len = utils.len(x1, y1, x2, y2)
  }
  setmetatable(new, Path.mt)
  return new
end

function Path.update(self, dt)
  self.t = utils.updateTime(self.t, 3 / self.len, dt)
end

function Path.pos(self)
  return utils.linearInterpolation(self.x1, self.x2, self.t), utils.linearInterpolation(self.y1, self.y2, self.t)
end

return Path