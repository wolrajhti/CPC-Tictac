local Animation = {}
Animation.mt = {__index = Animation}

local utils = require 'src.utils'

function Animation.new(frames, speed, x, y, width, height, ox, oy, once)
  if not width then
    width, height = frames[1]:getDimensions()
  end
  local new = {
    t = love.math.random(),
    update = utils.ternary(once, utils.updateAnimation, utils.updateAnimationLoop),
    speed = speed,
    texture = frames[1],
    frames = frames,
    quad = love.graphics.newQuad(x or 0, y or 0, width, height, frames[1]:getDimensions()),
    ox = ox or width / 2,
    oy = oy or height / 2,
    once = once
  }
  setmetatable(new, Animation.mt)
  return new
end

function Animation.updateLoop(self, dt)
  self.t = utils.updateTimeLoop(self.t, self.speed, dt)
  self.texture = self.frames[math.floor(#self.frames * self.t) + 1]
end

function Animation.updateOnce(self, dt)
  self.t = utils.updateTime(self.t, self.speed, dt)
  self.texture = self.frames[math.min(#self.frames, math.floor(#self.frames * self.t) + 1)]
end

function Animation.update(self, dt)
  if self.once then
    self:updateOnce(dt)
  else
    self:updateLoop(dt)
  end
end

function Animation.copy(self)
  local x, y, w, h = self.quad:getViewport()
  return Animation.new(self.frames, self.speed, x, y, w, h, self.ox, self.oy, self.once)
end

function Animation.draw(self, scale, x, y, reverse) -- reverse pas terrible (meme code que Quad.draw dommage)
  love.graphics.draw(self.texture, self.quad, x, y, 0, utils.ternary(reverse, -1, 1) * scale, scale, self.ox, self.oy)
end

return Animation