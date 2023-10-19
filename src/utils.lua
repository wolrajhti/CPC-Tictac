local utils = {}

function utils.setBackgroundImage(self, data)
  self.bw, self.bh = data.image:getDimensions()
end

function utils.setSize(self, w, h) -- à mettre dans utils
  self.W, self.H = w, h
  self.OX, self.OY = self.W / 2, self.H / 2
  self.ratio = self.ternary(
    self.W / self.H < self.bw / self.bh,
    self.W / self.bw,
    self.H / self.bh
  )
  self.ox, self.oy = (self.W - self.bw * self.ratio) / 2,
                       (self.H - self.bh * self.ratio) / 2
  self.cw = 16 * self.ratio
  self.ch = 8 * self.ratio
  self.sy = .5
end

function utils.setColor(self, r, g, b, a)
  self.r, self.g, self.b, self.a = love.graphics.getColor()
  love.graphics.setColor(r, g, b, a)
end

function utils.replaceColor(self, r, g, b, a)
  love.graphics.setColor(r, g, b, a)
end

function utils.setOpacity(self, a)
  self.r, self.g, self.b, self.a = love.graphics.getColor()
  love.graphics.setColor(self.r, self.g, self.b, a)
end

function utils.resetColor(self)
  love.graphics.setColor(self.r, self.g, self.b, self.a)
end

function utils.worldCoordinates(self, x, y)
  return self.ox + x * self.cw,
         self.oy + y * self.ch
end

function utils.cellCoordinates(self, x, y)
  return math.floor(((x - self.ox) + .5 * self.cw) / (self.cw)),
         math.floor(((y - self.oy) + .5 * self.ch) / (self.ch))
end

function utils.updateTime(t, speed, dt)
  return math.min(t + speed * dt, 1)
end

function utils.updateTimeLoop(t, speed, dt)
  return (t + speed * dt) % 1
end

function utils.linearInterpolation(x1, x2, t)
  return x1 + t * (x2 - x1)
end

function utils.len(x1, y1, x2, y2)
  return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

function utils.ternary(cond, T, F)
  if cond then return T else return F end
end

function utils.round(x)
  return math.floor(x + .5)
end

function utils.slice(tab, first, last)
  local slice = {}

  for i = math.max(0, first), math.min(last or first, #tab) do
    table.insert(slice, tab[i])
  end

  return slice
end

function utils.remove(tab, item)
  for i = #tab, 1, -1 do
    if tab[i] == item then
      return table.remove(tab, i)
    end
  end
end

function utils.shuffle(tab)
  local rnd = {}
  local comp = function(i1, i2)
    if not rnd[i1] then
      rnd[i1] = math.random()
    end
    if not rnd[i2] then
      rnd[i2] = math.random()
    end
    return rnd[i1] < rnd[i2]
  end
  table.sort(tab, comp)
end

return utils