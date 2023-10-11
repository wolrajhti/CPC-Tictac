local utils = {
  cells = {},
  orderedCells = {},
  walkableAreas = {
    -- ivan
    {x = 1, y = 2, w = 1, h = 6},
    {x = 2, y = 3, w = 1, h = 5},
    {x = 3, y = 5, w = 1, h = 2},
    -- redac
    {x = 3, y = 18, w = 15, h = 3},
    {x = 2, y = 21, w = 17, h = 2},
    {x = 1, y = 23, w = 19, h = 2},
    -- door
    {x = 13, y = 17, w = 1, h = 1}
  },
  r, g, b, a
}

function utils.initCells()
  for i, wa in ipairs(utils.walkableAreas) do
    for x = 0, wa.w do -- +1 pour l'init de l'obstacle du aimingSystem
      for y = 0, wa.h - 1 do
        utils.cellAt(wa.x + x, wa.y + y)
      end
    end
  end
end

local r, g, b, a
function utils.getColor()
  r, g, b, a = love.graphics.getColor()
end

function utils.setColor()
  love.graphics.setColor(r, g, b, a)
end

function utils.isWalkable(x, y)
  for i, wa in ipairs(utils.walkableAreas) do
    if wa.x <= x and x < wa.x + wa.w and
       wa.y <= y and y < wa.y + wa.h then
      return true
    end
  end
  return false
end

function utils.isRedacWalkable(x, y)
  for i, wa in ipairs(utils.walkableAreas) do
    if wa.x <= x and x < wa.x + wa.w and
       wa.y <= y and y < wa.y + wa.h then
      return 4 <= i and i <= 6
    end
  end
  return false
end

function utils.lineAt(y)
  for i = 4, 6 do
    if utils.walkableAreas[i].y <= y and y < utils.walkableAreas[i].y + utils.walkableAreas[i].h then
      return y, utils.walkableAreas[i].x, utils.walkableAreas[i].w
    end
  end
end

function utils.cellComp(c1, c2)
  return c1.y < c2.y
end

function utils.sortCells()
  table.sort(utils.orderedCells, utils.cellComp)
end

function utils.alert(cell, agents)
  local nearest = utils.findNearest(agents, cell)
  if nearest then
    nearest.agent.state = 'goingToWork'
    nearest.agent.headState = 'surprise'
    nearest.agent.animations.head.surprise.t = 0
    nearest.agent.target = cell
    cell.waitingFor = nearest.agent -- le rédacteur va vers la cellule
    nearest.agent:goTo(nearest.neighbor)
  end
end

function utils.updateCells(dt, gameState)
  local candidates = {}
  for i, cell in ipairs(utils.orderedCells) do
    for i = #cell.flying, 1, -1 do
      cell.flying[i]:update(dt)
      if not cell.flying[i].update then
        table.insert(cell.objs, table.remove(cell.flying, i))
        cell.waitingFor = false -- en attente d'un rédacteur
        utils.alert(cell, gameState.agents)
      end
    end
    for i = #cell.missed, 1, -1 do
      cell.missed[i]:update(dt)
      if not cell.missed[i].update then
        table.remove(cell.missed, i)
      end
    end
    if cell.waitingFor == false then
      table.insert(candidates, cell)
    end
  end

  if #candidates ~= 0 then
    utils.alert(candidates[math.random(1, #candidates)], gameState.agents)
  end
end

function utils.drawCells(gameState) -- beurk beurk beurk
  for i, cell in ipairs(utils.orderedCells) do
    for i, agent in ipairs(cell.agents) do
      if agent.behind == false then
        utils.drawAgent(agent, gameState)
      end
    end
    if #cell.objs > 0 or cell.h ~= 0 then
      if gameState.cell and gameState.cell.redacWalkable and gameState.state ~= 'GAME_OVER' and gameState.cell.y < cell.y then
        love.graphics.setColor(r, g, b, .2)
      end
      if cell.h ~= 0 and cell.redacWalkable then
        utils.drawQuad(gameState.data.mags[cell.h], utils.worldCoordinates(cell.x + cell.ox, cell.y + cell.oy))
      end
      for j, obj in ipairs(cell.objs) do
        utils.drawQuad(obj.quad, utils.worldCoordinates(cell.x + cell.ox, cell.y + cell.oy - cell.h * utils.sy))
      end
      if gameState.cell and gameState.cell.y < cell.y then
        utils.setColor()
      end
    end
    for i, agent in ipairs(cell.agents) do
      if agent.behind then
        utils.drawAgent(agent, gameState)
      end
    end
    for j, flying in ipairs(cell.flying) do
      utils.drawQuad(flying.quad, utils.worldCoordinates(flying.x, flying.y))
    end
    for j, missed in ipairs(cell.missed) do
      utils.drawQuad(missed.quad, utils.worldCoordinates(missed.x, missed.y))
    end
    -- if gameState.cell and gameState.cell.walkable and cell.walkable and gameState.cell.y == cell.y then
    --   love.graphics.print(cell.x - gameState.cell.x..' '..cell.h, utils.worldCoordinates(cell.x + cell.ox, cell.y + cell.oy))
    -- end
  end
end

function utils.cellIsEmpty(self)
  return #self.objs + #self.agents + #self.flying == 0
end

function utils.cellAt(x, y)
  if not utils.cells[y] then
    utils.cells[y] = {}
  end
  if not utils.cells[y][x] then
    local walkable = utils.isWalkable(x, y)
    utils.cells[y][x] = {
      x = x,
      y = y,
      h = utils.ternary(walkable, 0, 10),
      walkable = walkable,
      redacWalkable = utils.isRedacWalkable(x, y),
      objs = {},
      flying = {},
      missed = {},
      agents = {},
      ox = -.15 + .3 * love.math.random(),
      oy = -.15 + .3 * love.math.random(),
      isEmpty = utils.cellIsEmpty
    }
    table.insert(utils.orderedCells, utils.cells[y][x])
    utils.sortCells()
  end
  return utils.cells[y][x]
end

function utils.heightThreshold(cell)
  -- print('---------------')
  if not utils.cells[cell.y] then -- cas tout pourri, ne devrait pas exister
    return {}
  end

  local obs = {}
  local onTop
  for i, neighbor in pairs(utils.cells[cell.y]) do
    if neighbor.redacWalkable or cell.x < neighbor.x then
      onTop = neighbor.redacWalkable and neighbor:isEmpty()
      for dh = 0, neighbor.h do
        local h = neighbor.x + dh - cell.x
        -- print('h = '..neighbor.x..' + '..dh..' - '..cell.x.. ' = '..h..'(neighbor.x = '..neighbor.x..')')
        if not obs[h] or neighbor.x < obs[h].cell.x then
          obs[h] = {cell = neighbor, h = dh, onTop = onTop and dh == neighbor.h}
        end
      end
    end
  end
  return obs
end

function utils.worldCoordinates(x, y)
  return utils.ox + x * utils.cw * utils.ratio,
         utils.oy + y * utils.ch * utils.ratio
end

function utils.cellCoordinates(x, y)
  return math.floor(((x - utils.ox) + .5 * utils.cw * utils.ratio) / (utils.cw * utils.ratio)),
         math.floor(((y - utils.oy) + .5 * utils.ch * utils.ratio) / (utils.ch * utils.ratio))
end

function utils.initImage(filename, ox, oy)
  local image = love.graphics.newImage(filename)
  local w, h = image:getDimensions()
  return {
    image = image,
    w = w, -- à supprimer si useless
    h = h, -- à supprimer si useless
    ox = ox or w / 2,
    oy = oy or h / 2
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

function utils.updateAnimationLoop(self, dt)
  self.t = utils.updateTimeLoop(self.t, self.speed, dt)
  self.texture = self.frames[math.floor(#self.frames * self.t) + 1]
end

function utils.updateAnimation(self, dt)
  self.t = utils.updateTime(self.t, self.speed, dt)
  self.texture = self.frames[math.min(#self.frames, math.floor(#self.frames * self.t) + 1)]
end

function utils.initAnimation(frames, speed, x, y, width, height, ox, oy, once)
  if not width then
    width, height = frames[1]:getDimensions()
  end
  return {
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
end

function utils.copyAnimation(animation)
  return {
    t = animation.t,
    update = animation.update,
    speed = animation.speed,
    texture = animation.frames[1],
    frames = animation.frames,
    quad = animation.quad,
    ox = animation.ox,
    oy = animation.oy,
    once = animation.once
  }
end

function utils.initAgent(x, y, tongue, animations, stress)
  for i = 1, #tongue.texts.work do
    tongue.texts.work[i] = utils.text.init(tongue.font, tongue.texts.work[i])
  end
  for i = 1, #tongue.texts.leaving do
    tongue.texts.leaving[i] = utils.text.init(tongue.font, tongue.texts.leaving[i])
  end
  for i = 1, #tongue.texts.random do
    tongue.texts.random[i] = utils.text.init(tongue.font, tongue.texts.random[i])
  end
  for i = 1, #tongue.texts.aim do
    tongue.texts.aim[i] = utils.text.init(tongue.font, tongue.texts.aim[i])
  end
  local agent = {
    isIvan = false,
    isAckboo = false,
    tongue = tongue,
    x = x,
    y = y,
    state = 'idle',
    headState = 'idle',
    itemState = 'idle',
    reverse = love.math.random() < .5,
    behind = false,
    t = 0,
    path = nil,
    animations = animations,
    update = utils.updateAgent,
    goTo = utils.goTo,
    stress = 0--stress or love.math.random(0, 7)
  }
  agent.to = utils.cellAt(agent.x, agent.y)
  table.insert(agent.to.agents, agent)
  return agent
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

function utils.initPath(x1, y1, x2, y2)
  local len = utils.len(x1, y1, x2, y2)
  return {
    update = function(t, dt)
      return utils.updateTime(t, 3 / len, dt)
    end,
    at = function(t)
      return utils.linearInterpolation(x1, x2, t), utils.linearInterpolation(y1, y2, t)
    end
  }
end

function utils.drawImage(data, x, y)
  love.graphics.draw(data.image, x, y, 0, utils.ratio, utils.ratio, data.ox, data.oy)
end

function utils.drawQuad(data, x, y, reverse) -- reverse pas terrible
  love.graphics.draw(data.texture, data.quad, x, y, 0, utils.ternary(reverse, -1, 1) * utils.ratio, utils.ratio, data.ox, data.oy)
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

function utils.goTo(self, cell, ox, oy)
  self.from = self.to
  utils.remove(self.to.agents, self)
  self.to = cell
  table.insert(self.to.agents, self)
  self.t = 0
  self.path = utils.initPath(self.from.x, self.from.y, (self.to.x + (ox or 0)), (self.to.y + (oy or 0)))
  self.reverse = (self.to.x + (ox or 0)) < self.from.x
  self.behind = (self.to.y + (oy or 0)) < self.from.y
end

function utils.updateAgent(agent, dt, gameState)
  agent.animations.body[agent.state]:update(dt)
  agent.animations.head[agent.headState]:update(dt)
  if agent.isAckboo then
    agent.animations.item[agent.itemState]:update(dt)
  end

  if agent.tongue.current then
    agent.tongue:update(dt, agent.state)
  end

  -- body
  if agent.state == 'idle' then
    if agent.stress > 7 then
      agent.state = 'leaving'
      agent.headState = 'cry'
      agent.tongue:leaving()
      agent.animations.head.cry.t = 0
      agent:goTo(gameState.door.cell, gameState.door.ox)
    elseif love.math.random() < .5 * dt and (gameState.state ~= 'IDLE' or not agent.isIvan) then
      local candidates = {}
      local origin = utils.cellAt(agent.x, agent.y)
      local next
      next = utils.cellAt(agent.x - 1, agent.y)
      if next.walkable and origin.redacWalkable == next.redacWalkable and next:isEmpty() and agent.from ~= next then
        table.insert(candidates, next)
      end
      next = utils.cellAt(agent.x, agent.y - 1)
      if next.walkable and origin.redacWalkable == next.redacWalkable and next:isEmpty() and agent.from ~= next then
        table.insert(candidates, next)
      end
      next = utils.cellAt(agent.x + 1, agent.y)
      if next.walkable and origin.redacWalkable == next.redacWalkable and next:isEmpty() and agent.from ~= next then
        table.insert(candidates, next)
      end
      next = utils.cellAt(agent.x, agent.y + 1)
      if next.walkable and origin.redacWalkable == next.redacWalkable and next:isEmpty() and agent.from ~= next then
        table.insert(candidates, next)
      end
      if #candidates > 0 then
        agent.state = 'walking'
        agent:goTo(candidates[love.math.random(1, #candidates)])
      end
    end
  elseif agent.state == 'walking' then
    agent.t = agent.path.update(agent.t, dt)
    agent.x, agent.y = agent.path.at(agent.t)
    if agent.t == 1 then
      agent.state = 'idle'
    end
  elseif agent.state == 'leaving' then
    agent.t = agent.path.update(agent.t, dt)
    agent.x, agent.y = agent.path.at(agent.t)
  elseif agent.state == 'goingToWork' then -- faire un 'nextState' ou 'todoList'
    agent.t = agent.path.update(agent.t, dt)
    agent.x, agent.y = agent.path.at(agent.t)
    if agent.t == 1 then
      agent.state = 'work'
    end
  elseif agent.state == 'work' then
    local objs = agent.target.objs
    table.remove(objs, #objs) -- on retire le dernier objet (un avion)
    table.insert(objs, {quad = gameState.data.article})
    gameState:setArticleCount(gameState.articleCount + 1)
    agent.target.waitingFor = nil -- le rédacteur a ramasser l'avion
    agent.target = nil
    agent.stress = math.min(agent.stress + 1, 8)
    agent.state = 'idle'
    if love.math.random() < .2 * dt then
      agent.tongue:work()
    end
  end

  -- head
  if agent.headState == 'idle' then
    if love.math.random() < .1 * dt then
      agent.headState = 'blink'
      agent.animations.head.blink.t = 0
    elseif love.math.random() < .05 * dt then
      agent.tongue:random()
    end
  elseif agent.headState ~= 'cry' then
    if agent.animations.head[agent.headState].t == 1 then
      agent.headState = 'idle'
      agent.animations.head.blink.t = 0
    end
  end
end

function utils.drawAgent(agent, gameState)
  local sx, sy = utils.worldCoordinates(agent.x, agent.y)
  utils.drawQuad(agent.animations.body[agent.state], sx, sy, agent.reverse)
  utils.drawQuad(agent.animations.head[agent.headState], sx, sy, agent.reverse)
  if agent.isAckboo then
    utils.drawQuad(agent.animations.item[agent.itemState], sx, sy, agent.reverse)
  end
  if agent.tongue.current then
    utils.text.drawSpeak(agent.tongue, sx, sy)
  end
  if agent.stress > 0 then
    utils.drawQuad(gameState.data.stress[agent.stress], sx, sy)
  end
end

function utils.updatePlane(self, dt)
  if self.exploding == true then
    if self.animations.exploding.t == 1 then
      self.update = nil
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
      else
        self.update = nil
      end
    end
  end
end

local x, y
function utils.drawWalkingAreas()
  utils.getColor()
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
  utils.setColor()
end

function utils.drawLine(y, pos, width)
  utils.getColor()
  love.graphics.setColor(.1, .1, .1, .2)
  x, y = utils.worldCoordinates(pos, y)
  love.graphics.rectangle(
    'fill',
    x - .5 * utils.cw * utils.ratio,
    y - .5 * utils.ch * utils.ratio,
    width * utils.cw * utils.ratio,
    1 * utils.ch * utils.ratio
  )
  utils.setColor()
end

function utils.drawCalendar(gameState)
  utils.getColor()
  -- if gameState.weekend then
  --   love.graphics.setColor(.2, 1, .2)
  -- elseif gameState.endOfTheMonth then
  --   love.graphics.setColor(1, 1, .2)
  -- else
    love.graphics.setColor(172 / 255, 50 / 255, 50 / 255, 100 / 255)
  -- end
  local day
  for i = 1, gameState.day - 1 do
    day = gameState.CALENDAR_CELLS[i]
    love.graphics.rectangle('fill', utils.ox + day[1] * utils.ratio, utils.oy + day[2] * utils.ratio, 2 * utils.ratio, 2 * utils.ratio)
  end
  day = gameState.CALENDAR_CELLS[gameState.day]
  love.graphics.rectangle('fill', utils.ox + day[1] * utils.ratio, utils.oy + day[2] * utils.ratio, 1 * utils.ratio, 2 * utils.ratio)
  love.graphics.rectangle('fill', utils.ox + (day[1] + 1) * utils.ratio, utils.oy + (day[2] + 1) * utils.ratio, 1 * utils.ratio, 1 * utils.ratio)
  utils.setColor()
end

local N = {-1, -1, 0, -1, 1, -1, 1, 0, 1, 1, 0, 1, -1, 1, -1, 0}
local MAX_DIST = 4 * math.sqrt(2) -- TODO à réduire en fonction du temps qui passe -> plus de mag -> moins de perception
function utils.findNearest(agents, cell)
  local candidates = {}
  local neighbor
  local dist
  local minDist = MAX_DIST
  for i, agent in ipairs(agents) do
    if agent.state == 'idle' then -- l'agent est libre
      minDist = utils.len(agent.x, agent.y, cell.x, cell.y)
      if minDist < MAX_DIST then -- et n'est pas trop loin
        for k = 1, #N, 2 do -- pour chaque case voisine
          neighbor = utils.cellAt(cell.x + N[k], cell.y + N[k + 1])
          if neighbor.redacWalkable and neighbor:isEmpty() then -- si disponible
            dist = utils.len(agent.x, agent.y, neighbor.x, neighbor.y)
            if dist < minDist then
              candidates = {{agent = agent, neighbor = neighbor}}
              minDist = dist
            elseif dist == minDist then
              table.insert(candidates, {agent = agent, neighbor = neighbor})
            end
          end
        end
      end
    end
  end

  if #candidates ~= 0 then
    return candidates[math.random(1, #candidates)]
  end
end

require 'src.text' (utils) -- à généraliser

utils.initCells() -- ULTRA SALE

utils.cellAt(10, 45).h = 3
utils.cellAt(14, 45).h = 5

return utils