local Calendar = {}
Calendar.mt = {__index = Calendar}

local utils = require 'src.utils'

function Calendar.new(speed, cells)
  local new = {
    t = 0,
    speed = speed,
    day = 0,
    endOfTheMonth = false,
    weekend = false,
    cells = cells -- {x = 42, y = 42} au lieu de {42, 42} ?
  }
  setmetatable(new, Calendar.mt)
  return new
end

function Calendar.update(self, dt)
  self.t = self.t + self.speed * dt
  local events = {}
  while self.t > 1 do
    self.t = self.t - 1
    self.day = self.day + 1
    if self.day > 30 then
      self.day = self.day - 30
    end
    if self.day == 30 then
      table.insert(events, 'endOfTheMonth') -- TODO event emitter plutôt
    elseif self.day == 6 or self.day == 13 or self.day == 20 or self.day == 27 then
      table.insert(events, 'weekend') -- TODO event emitter plutôt
    end
  end
  return events
end

function Calendar.draw(self)
  utils:setColor(172 / 255, 50 / 255, 50 / 255, 100 / 255)
  local cell
  for i = 1, self.day - 1 do
    cell = self.cells[i]
    love.graphics.rectangle('fill', utils.ox + cell[1] * utils.ratio, utils.oy + day[2] * utils.ratio, 2 * utils.ratio, 2 * utils.ratio)
  end
  cell = self.cells[self.day]
  love.graphics.rectangle('fill', utils.ox + cell[1] * utils.ratio, utils.oy + day[2] * utils.ratio, 1 * utils.ratio, 2 * utils.ratio)
  love.graphics.rectangle('fill', utils.ox + (cell[1] + 1) * utils.ratio, utils.oy + (day[2] + 1) * utils.ratio, 1 * utils.ratio, 1 * utils.ratio)
  utils:resetColor()
end