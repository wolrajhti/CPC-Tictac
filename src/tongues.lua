local Tongue = {}
Tongue.mt = {__index = Tongue}

local COUNT = 0;
local MAX = 3; -- BOF BOF

function Tongue.new(color, background, quotes)
  local new = {
    current = nil,
    t = 0,
    color = color,
    background = background,
    quotes = quotes,
    unused = {work = {}, random = {}, leaving = {}, aim = {}}
  }
  setmetatable(new, Tongue.mt)
  return new
end

function Tongue.update(self, dt) -- body state
  self.t = self.t + dt
  if self.t > 6 then
    self.current = nil
    if self.callback then
      self.callback() -- TODO horrible d'avoir a passer une fonction... il faudrait avoir accès à l'agent
    end
    COUNT = COUNT - 1
  end
end

function Tongue.randomWork(self)
  if #self.unused.work > 0 then
    local i = love.math.random(1, #self.unused.work)
    return table.remove(self.unused, i)
  else
    for i, quote in ipairs(self.quotes.work) do
      table.insert(self.unused.work, quote)
    end
    return self:randomWork()
  end
end

function Tongue.work(self, callback)
  if COUNT < MAX and not self.current and #self.quotes.work > 0 then
    self.current = self:randomWork()
    self.t = 0
    self.callback = callback
    COUNT = COUNT + 1
  end
end

function Tongue.leaving(self, callback)
  if COUNT < MAX then
    self.current = self.quotes.leaving[love.math.random(1, #self.quotes.leaving)]
    self.t = 0
    self.callback = callback
    COUNT = COUNT + 1
  end
end

function Tongue.random(self, callback)
  if COUNT < MAX and not self.current and #self.quotes.random > 0 then
    self.current = self.quotes.random[love.math.random(1, #self.quotes.random)]
    self.t = 0
    self.callback = callback
    COUNT = COUNT + 1
  end
end

function Tongue.aim(self, callback)
  if COUNT < MAX and not self.current and #self.quotes.aim > 0 then
    self.current = self.quotes.aim[love.math.random(1, #self.quotes.aim)]
    self.t = 0
    self.callback = callback
    COUNT = COUNT + 1
  end
end

function Tongue.draw(self, x, y)
  if self.current then
    self.current:drawSpeak(x, y, self.color, self.background)
  end
end

return Tongue
