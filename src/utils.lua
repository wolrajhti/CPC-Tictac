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
        cell.obj = table.remove(cell.flying, i)
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
    if cell.obj or cell.h ~= 0 then
      if gameState.cell and gameState.state ~= 'GAME_OVER' and gameState.cell.y < cell.y then
        love.graphics.setColor(r, g, b, .2)
      end
      if cell.h ~= 0 and cell.redacWalkable then
        gameState.data.mags[cell.h]:draw(utils.ratio, utils:worldCoordinates(cell.cx, cell.cy))
      end
      if cell.obj then
        cell.obj.quad:draw(utils.ratio, utils:worldCoordinates(cell.cx, cell.cy - cell.h * utils.sy))
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
      flying.quad:draw(utils.ratio, utils:worldCoordinates(flying.x, flying.y))
    end
    for j, missed in ipairs(cell.missed) do
      missed.quad:draw(utils.ratio, utils:worldCoordinates(missed.x, missed.y))
    end
    -- if gameState.cell and gameState.cell.walkable and cell.walkable and gameState.cell.y == cell.y then
    --   love.graphics.print(cell.x - gameState.cell.x..' '..cell.h, utils:worldCoordinates(cell.cx, cell.cy))
    -- end
  end
end

function utils.drawTexts(gameState)
  for i, cell in ipairs(utils.orderedCells) do
    for i, agent in ipairs(cell.agents) do
      utils.drawText(agent, gameState)
    end
  end
end

function utils.cellIsEmpty(self, skipH)
  return not self.obj and #self.agents + #self.flying + utils.ternary(skipH, 0, self.h) == 0
end

function utils.cellAt(x, y)
  if not utils.cells[y] then
    utils.cells[y] = {}
  end
  if not utils.cells[y][x] then
    local walkable = utils.isWalkable(x, y)
    local ox, oy = -.15 + .3 * love.math.random(), -.15 + .3 * love.math.random()
    utils.cells[y][x] = {
      x = x,
      y = y,
      h = utils.ternary(walkable, 0, 10),
      walkable = walkable,
      redacWalkable = utils.isRedacWalkable(x, y),
      obj = nil,
      flying = {},
      missed = {},
      agents = {},
      ox = ox,
      oy = oy,
      cx = x + ox, -- coordonnées des objets
      cy = y + oy,
      ax = x, -- coordonnées des agents (custom pour la porte de secours)
      ay = y,
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
      onTop = neighbor.redacWalkable and neighbor:isEmpty(true)
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

function utils.worldCoordinates(self, x, y)
  return self.ox + x * self.cw,
         self.oy + y * self.ch
end

function utils.cellCoordinates(self, x, y)
  return math.floor(((x - self.ox) + .5 * self.cw) / (self.cw)),
         math.floor(((y - self.oy) + .5 * self.ch) / (self.ch))
end

function utils.initAgent(id, cell, tongue, animations, stress)
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
    id = id,
    tongue = tongue,
    from = cell,
    to = cell,
    x = cell.ax,
    y = cell.ay,
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
  table.insert(cell.agents, agent)
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

function utils.ternary(cond, T, F)
  if cond then return T else return F end
end

function utils.round(x)
  return math.floor(x + .5)
end

function utils.slice(tab, first, last)
  local slice = {}

  for i = math.max(1, first or 1), math.min(last or #tab, #tab) do
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

function utils.goTo(self, cell) -- à modifier
  self.from = self.to
  utils.remove(self.to.agents, self)
  self.to = cell
  table.insert(self.to.agents, self)
  self.t = 0
  self.path = utils.initPath(self.from.ax, self.from.ay, self.to.ax, self.to.ay)
  self.reverse = self.to.ax < self.from.ax
  self.behind = self.to.ay < self.from.ay
end

function utils.updateAgent(agent, dt, gameState)
  agent.animations.body[agent.state]:update(dt)
  agent.animations.head[agent.headState]:update(dt)
  if agent.id == 'Ackboo' then
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
      agent:goTo(gameState.door.cell)
    elseif love.math.random() < .5 * dt and (gameState.state ~= 'IDLE' or agent.id ~= 'Ivan') then -- ivan ne doit pas bouger en idle pour que le 1er aim fonctionne correctement
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
    agent.target.obj = {quad = gameState.data.article}
    gameState:setArticleCount(gameState.articleCount + 1)
    agent.target.waitingFor = nil -- le rédacteur a ramasser l'avion
    agent.target = nil
    agent.stress = math.min(agent.stress + 1, 8)
    agent.state = 'idle'
    if love.math.random() < 10 * dt then
      agent.headState = 'speak'
      agent.animations.head.speak.t = 0
      agent.tongue:work(function() agent.headState = 'idle' end)
    end
  end

  -- head
  if agent.headState == 'idle' then
    if love.math.random() < .1 * dt then
      agent.headState = 'blink'
      agent.animations.head.blink.t = 0
    elseif love.math.random() < .025 * dt then
      if agent.id == 'Ackboo' then
        for i, a in ipairs(gameState.agents) do
          if i ~= 0 and a.headState == 'idle' then
            a.headState = utils.ternary(a.id == 'Ackboo', 'speak', 'laugh')
            a.animations.head[a.headState].t = 0
          end
        end
        agent.tongue:random(function ()
          for i, a in ipairs(gameState.agents) do
            if i ~= 0 and not a.tongue.current then
              a.headState = 'idle'
            end
          end
        end)
      elseif agent.id == 'Ivan' then
        agent.headState = 'speak'
        agent.animations.head.speak.t = 0
        agent.tongue:random(function() agent.headState = 'idle' end)
      else
        for i, a in ipairs(gameState.agents) do
          if a.id == 'Ackboo' or a == agent and a.headState == 'idle' then
            a.headState = utils.ternary(a.id == 'Ackboo', 'laugh', 'speak')
            a.animations.head[a.headState].t = 0
          end
        end
        agent.tongue:random(function ()
          for i, a in ipairs(gameState.agents) do
            if a.id == 'Ackboo' or a == agent and not a.tongue.current then
              a.headState = 'idle'
            end
          end
        end)
      end
    end
  elseif agent.headState ~= 'cry' then
    if agent.animations.head[agent.headState].t == 1 then
      agent.headState = 'idle'
    end
  end
end

function utils.drawAgent(agent, gameState)
  local sx, sy = utils:worldCoordinates(agent.x, agent.y)
  agent.animations.body[agent.state]:draw(utils.ratio, sx, sy, agent.reverse)
  agent.animations.head[agent.headState]:draw(utils.ratio, sx, sy, agent.reverse)
  if agent.id == 'Ackboo' then
    agent.animations.item[agent.itemState]:draw(utils.ratio, sx, sy, agent.reverse)
  end
  if agent.stress > 0 then
    gameState.data.stress[agent.stress]:draw(utils.ratio, sx, sy)
  end
end

function utils.drawText(agent, gameState)
  if agent.tongue.current then
    local sx, sy = utils:worldCoordinates(agent.x, agent.y)
    utils.text.drawSpeak(agent.tongue, sx, sy)
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
    x, y = utils:worldCoordinates(wa.x, wa.y)
    love.graphics.rectangle(
      'fill',
      x - .5 * utils.cw,
      y - .5 * utils.ch,
      wa.w * utils.cw,
      wa.h * utils.ch
    )
  end
  utils.setColor()
end

function utils.drawLine(y, pos, width)
  utils.getColor()
  love.graphics.setColor(.1, .1, .1, .2)
  x, y = utils:worldCoordinates(pos, y)
  love.graphics.rectangle(
    'fill',
    x - .5 * utils.cw,
    y - .5 * utils.ch,
    width * utils.cw,
    1 * utils.ch
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

-- local N = {-1, -1, 0, -1, 1, -1, 1, 0, 1, 1, 0, 1, -1, 1, -1, 0}
local N = {0, -1, 1, 0, 0, 1, -1, 0}
local MAX_DIST = 4 * math.sqrt(2) -- TODO à réduire en fonction du temps qui passe -> plus de mag -> moins de perception
function utils.findNearest(agents, cell)
  local candidates = {}
  local neighbor
  local dist
  local minDist = MAX_DIST
  for i, agent in ipairs(agents) do
    if agent.state == 'idle' then -- l'agent est libre
      dist = utils.len(agent.x, agent.y, cell.x, cell.y)
      if dist < MAX_DIST then -- et n'est pas trop loin
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

require 'src.text' (utils) -- à généraliser

utils.initCells() -- ULTRA SALE

return utils