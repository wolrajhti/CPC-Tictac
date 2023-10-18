local WalkableArea = {}
WalkableArea.mt = {__index = WalkableArea}

function WalkableArea.new(x, y, w, h)
  local new = {
    x = x, y = y,
    w = w, h = h
  }
  setmetatable(new, WalkableArea.mt)
  return new
end

function WalkableArea.contains(self, x, y)
  return self.x <= x and x < self.x + self.w and
         self.y <= y and y < self.y + self.h
end

return WalkableArea