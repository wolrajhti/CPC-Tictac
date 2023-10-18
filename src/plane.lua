local Plane = {}
Plane.mt = {__index = Plane}

local PX1, PY1 = -2, 15 -- départ des avions
local FLYING_SPEED_MIN, FLYING_SPEED_MAX = 10, 30 -- vitesse des avions (variable ?)

local utils = require 'src.utils'

function Plane.new(quad, exploding, x, y)
  local new = {
    x1 = PX1, y1 = PY1,
    x = PX1, y = PY1,
    x2 = x, y2 = y,
    speed = love.math.random(FLYING_SPEED_MIN, FLYING_SPEED_MAX),
    t = 0,
    len = utils.len(PX1, PY1, x, y),
    quad = quad,
    animations = {exploding = exploding:copy()}
  }
  new.animations.exploding.t = 0
  setmetatable(new, Plane.mt)
  return new
end

function Plane.update(self, dt)
  if self.exploding == true then
    if self.animations.exploding.t == 1 then
    else
      self.animations.exploding:update(dt)
    end
  else
    self.t = utils.updateTime(self.t, self.speed / self.len, dt)
    self.x = utils.linearInterpolation(self.x1, self.x2, self.t)
    self.y = utils.linearInterpolation(self.y1, self.y2, self.t)
    if self.t == 1 then
      if self.exploding == false then
        self.exploding = true
        self.quad = self.animations.exploding
      end
    end
  end
end

function Plane.miss(self, cell)
  self.exploding = false
  table.insert(cell.missed, self)
end

return Plane