local Text = {}
Text.mt = {__index = Text}

local utils = require 'src.utils'

function Text.new(font, str, ox, oy)
  local text = love.graphics.newText(font, str)
  local w, h = text:getDimensions()
  local new = {
    len = #str, -- useless ?
    font = font,
    text = text,
    w = w,
    h = h,
    ox = ox or w / 2,
    oy = oy or h / 2
  }
  setmetatable(new, Text.mt)
  return new
end

function Text.set(self, str, ox, oy)
  self.text = love.graphics.newText(self.font, str)
  self.len = #str
  self.w, self.h = self.text:getDimensions()
  self.ox, self.oy = ox or self.w / 2, oy or self.h / 2
end

function Text.drawSpeak(self, x, y, color, background)
  local xMin = x - (self.w / 8 + 1) * utils.ratio
  local yMin = y - (self.h / 4 + 3) * utils.ratio - 29 * utils.ratio - (utils.ratio / 2)
  local w = (self.w / 4 + 2) * utils.ratio
  local h = (self.h / 4 + 2) * utils.ratio
  local xOffset, yOffset = 0, 0
  if xMin < 4 * utils.ratio then
    xOffset = 4 * utils.ratio - xMin
  elseif (utils.bw - 4) * utils.ratio < xMin + w then
    xOffset = (utils.bw - 4) * utils.ratio - (xMin + w)
  end
  if yMin < 4 * utils.ratio then
    yOffset = 4 * utils.ratio - yMin
  elseif (utils.bh - 4) * utils.ratio < yMin + h then
    yOffset = (utils.bh - 4) * utils.ratio - (yMin + h)
  end
  utils:getColor(background.r, background.g, background.b, background.a)
  love.graphics.rectangle('fill',
    xMin + xOffset, yMin + yOffset,
    w, h
  )
  love.graphics.setColor(color.r, color.g, color.b, color.a)
  love.graphics.draw(
    self.text,
    x + xOffset, y - 29 * utils.ratio - 3 * utils.ratio + yOffset,
    0,
    utils.ratio / 4, utils.ratio / 4,
    self.w / 2, self.h
  )
  utils:resetColor()
end

function Text.draw(self, x, y)
  love.graphics.draw(self.text, x, y, 0, utils.ratio / 2, utils.ratio / 2, self.ox, self.oy)
end

function Text.drawSmall(self, x, y)
  love.graphics.draw(self.text, x, y, 0, utils.ratio / 4, utils.ratio / 4, self.ox, self.oy)
end

function Text.drawTitle(self, x, y)
  love.graphics.draw(self.text, x, y, 0, utils.ratio, utils.ratio, self.ox, self.oy)
end

return Text
