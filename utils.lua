local utils = {
  ratio = 1,
  cw = 16,
  ch = 4,
  cells = {},
  walkableAreas = {
    -- ivan
    {x = 1, y = 4, w = 1, h = 12},
    {x = 2, y = 6, w = 1, h = 10},
    {x = 3, y = 10, w = 1, h = 3},
    -- redac
    {x = 3, y = 36, w = 15, h = 5},
    {x = 2, y = 41, w = 17, h = 6},
    {x = 1, y = 47, w = 19, h = 2}
  }
}

function utils.isWalkable(x, y)
  for i, wa in ipairs(utils.walkableAreas) do
    if wa.x <= x and x < wa.x + wa.w and
       wa.y <= y and y < wa.y + wa.h then
      return true
    end
  end
  return false
end

function utils.cellAt(x, y)
  x, y = utils.cellCoordinates(x, y)
  if not utils.cells[x] then
    if not utils.isWalkable(x, y) then return nil end
    utils.cells[x] = {[y] = {x = x, y = y, objs = {}}}
  elseif not utils.cells[x][y] then
    if not utils.isWalkable(x, y) then return nil end
    utils.cells[x][y] = {x = x, y = y, objs = {}}
  end
  return utils.cells[x][y]
end

function utils.targetHeight(cell)
  local h = 0
  for i, v in ipairs(cell.objs) do
    h = h + v.h
  end
  return h
end

function utils.worldCoordinates(x, y)
  return x * utils.cw * utils.ratio, y * utils.ch * utils.ratio
end

function utils.cellCoordinates(x, y)
  return math.floor((x + .5 * utils.cw * utils.ratio) / (utils.cw * utils.ratio)),
         math.floor((y + .5 * utils.ch * utils.ratio) / (utils.ch * utils.ratio))
end

function utils.initImage(filename)
  local image = love.graphics.newImage(filename)
  local w, h = image:getDimensions()
  return {
    image = image,
    w = w, -- à supprimer si useless
    h = h, -- à supprimer si useless
    ox = w / 2,
    oy = h / 2
  }
end

function utils.initQuad(texture, x, y, width, height, ox, oy)
  return {
    texture = texture,
    quad = love.graphics.newQuad(x, y, width, height, texture:getDimensions()),
    ox = ox or width / 2,
    oy = oy or height / 2
  }
end

function utils.initAnimation(frames, speed, x, y, width, height, ox, oy)
  local t = math.random()
  return {
    update = function (self, dt)
      t = (t + speed * dt) % 1
      self.texture = frames[math.floor(#frames * t) + 1]
    end,
    texture = frames[1],
    quad = love.graphics.newQuad(x, y, width, height, frames[1]:getDimensions()),
    ox = ox or width / 2,
    oy = oy or height / 2
  }
end

function utils.initText(font, str)
  text = love.graphics.newText(font, str)
  local w, h = text:getDimensions()
  return {
    text = text,
    w = w,
    h = h
  }
end

function utils.initPath(x1, y1, x2, y2)
  local len = math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
  return {
    update = function(t, dt)
      return math.min(t + (3 / len) * dt, 1)
    end,
    at = function(t)
      return x1 + t * (x2 - x1), y1 + t * (y2 - y1)
    end
  }
end

function utils.drawImage(data, x, y)
  love.graphics.draw(data.image, x, y, 0, utils.ratio, utils.ratio, data.ox, data.oy)
end

function utils.drawQuad(data, x, y, reverse) -- reverse pas terrible
  love.graphics.draw(data.texture, data.quad, x, y, 0, utils.ternary(reverse, -1, 1) * utils.ratio, utils.ratio, data.ox, data.oy)
end

local r, g, b, a
function utils.drawText(data, x, y)
  r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(0, 0, 0, 0.3)
  love.graphics.rectangle('fill',
    x - (data.w / 2 + utils.ratio),
    y - (data.h + 3 * utils.ratio) - 29 * utils.ratio,
    data.w + 2 * utils.ratio,
    data.h + 2 * utils.ratio
  )
  -- love.graphics.setColor(0, 0, 0)
  -- love.graphics.rectangle('line', x - (tw / 2 + utils.ratio), y - (th + 3 * utils.ratio) - 29 * utils.ratio, tw + 2 * utils.ratio, th + 2 * utils.ratio)
  love.graphics.setColor(1, 1, 1)
  -- voir si plus performant si on utilise utils.ratio, utils.ratio à la place de 1, 1
  love.graphics.draw(text, x, y - 29 * utils.ratio, 0, 1, 1, data.w / 2, data.h + 3 * utils.ratio)
  love.graphics.circle('fill', x, y, 4)
  love.graphics.setColor(r, g, b, a)
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

function utils.updateAgent(agent, dt)
  agent.animations[agent.state]:update(dt)
  if agent.state == 'idle' then
    if math.random() < .5 * dt then
      local candidates = {}
      local next
      next = utils.cellAt(utils.worldCoordinates(agent.x - 1, agent.y))
      if next then
        table.insert(candidates, {cell = next, reverse = true})
      end
      next = utils.cellAt(utils.worldCoordinates(agent.x, agent.y - 1))
      if next then
        table.insert(candidates, {cell = next, reverse = true})
      end
      next = utils.cellAt(utils.worldCoordinates(agent.x + 1, agent.y))
      if next then
        table.insert(candidates, {cell = next, reverse = false})
      end
      next = utils.cellAt(utils.worldCoordinates(agent.x, agent.y + 1))
      if next then
        table.insert(candidates, {cell = next, reverse = false})
      end
      if #candidates > 0 then
        next = candidates[math.random(1, #candidates)]
        agent.state = 'walking'
        agent.t = 0
        agent.path = utils.initPath(agent.x, agent.y, next.cell.x, next.cell.y)
        agent.reverse = next.reverse
      end
    elseif math.random() < .1 * dt then
      agent.state = 'blink'
      agent.t = 0
    end
  elseif agent.state == 'walking' then
    agent.t = agent.path.update(agent.t, dt)
    agent.x, agent.y = agent.path.at(agent.t)
    if agent.t == 1 then
      agent.state = 'idle'
    end
  elseif agent.state == 'blink' then
    agent.t = agent.t + dt
    if agent.t > 1 then
      agent.state = 'idle'
    end
  end
end

function utils.drawAgent(agent)
  local sx, sy = utils.worldCoordinates(agent.x, agent.y)
  utils.drawQuad(agent.animations[agent.state], sx, sy, agent.reverse)
end

function utils.updatePlane(self, dt)
  self.t = math.min(self.t + self.speed * dt / self.len, 1)
  self.x = self.x1 + self.t * (self.x2 - self.x1)
  self.y = self.y1 + self.t * (self.y2 - self.y1)
  if self.t == 1 then
    self.update = nil
  end
end

local x, y
function utils.drawWalkingAreas()
  r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(1, .7, .7, .5)
  for i, wa in ipairs(utils.walkableAreas) do
    x, y = utils.worldCoordinates(wa.x, wa.y)
    love.graphics.rectangle(
      'fill',
      x - .5 * utils.cw * utils.ratio,
      y - .5 * utils.ch * utils.ratio,
      wa.w * utils.cw * utils.ratio,
      wa.h * utils.ch * utils.ratio
    )
  end
  love.graphics.setColor(r, g, b, a)
end

return utils