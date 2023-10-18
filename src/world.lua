local World = {}
World.mt = {__index = World}

local Cell = require 'src.cell'

function World.new(walkableAreas, redacWalkableAreas)
  local new = {
    cells = {},
    cells = {},
    orderedCells = {},
    walkableAreas = walkableAreas,
    redacWalkableAreas = redacWalkableAreas
  }
  setmetatable(new, World.mt)
  new:init() -- on instancie toutes les cellules "walkable
  return new
end

function World.init(self)
  for i, wa in ipairs(self.walkableAreas) do
    for x = 0, wa.w do -- +1 pour l'init de l'obstacle du aimingSystem (les cellules non walkable ont une h de 10)
      for y = 0, wa.h - 1 do
        self:cellAt(wa.x + x, wa.y + y)
      end
    end
  end
end

function World.isWalkable(self, x, y)
  if self:isRedacWalkable(x, y) then
    return true
  else
    for i, wa in ipairs(self.walkableAreas) do
      if wa:contains(x, y) then
        return true
      end
    end
  end
  return false
end

function World.isRedacWalkable(self, x, y)
  for i, rwa in ipairs(self.redacWalkableAreas) do
    if rwa:contains(x, y) then
      return true
    end
  end
  return false
end

function World.drawLineAt(self, x, y)
  for i, rwa in ipairs(self.redacWalkableAreas) do
    if rwa:contains(x, y) then
      utils:setColor(.1, .1, .1, .2)
      x, y = utils:worldCoordinates(rwa.x, y)
      love.graphics.rectangle(
        'fill',
        x - .5 * utils.cw,
        y - .5 * utils.ch,
        rwa.w * utils.cw,
        1 * utils.ch
      )
      utils:resetColor()
      return
    end
  end
end

function World.sortCells(self)
  table.sort(self.orderedCells, Cell.Comp)
end

function World.cellAt(self, x, y)
  if not self.cells[y] then
    self.cells[y] = {}
  end
  if not self.cells[y][x] then
    self.cells[y][x] = Cell.new(x, y, self:isWalkable(x, y), self:isRedacWalkable(x, y))
    table.insert(self.orderedCells, self.cells[y][x])
    self:sortCells()
  end
  return self.cells[y][x]
end

function World.update(self, dt, gameState)
  local candidates = {}
  for i, cell in ipairs(self.orderedCells) do
    for i = #cell.flying, 1, -1 do
      cell.flying[i]:update(dt)
      if not cell.flying[i].update then
        table.insert(cell.objs, table.remove(cell.flying, i))
        cell.waitingFor = false -- en attente d'un rédacteur
        self:alert(cell, gameState.agents)
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
    self:alert(candidates[math.random(1, #candidates)], gameState.agents)
  end
end

function World.drawCells(self, gameState) -- beurk beurk beurk
  for i, cell in ipairs(self.orderedCells) do
    cell:draw(gameState)
  end
end

function World.drawWalkingAreas(self)
  utils:setColor(1, .7, .7, .5)
  for i, wa in ipairs(self.walkableAreas) do
    x, y = utils:worldCoordinates(wa.x, wa.y)
    love.graphics.rectangle(
      'fill',
      x - .5 * utils.cw,
      y - .5 * utils.ch,
      wa.w * utils.cw,
      wa.h * utils.ch
    )
  end
  utils:resetColor()
end

function World.alert(self, cell, agents)
  local nearest = self:findNearest(agents)
  if nearest then
    nearest.agent.state = 'goingToWork'
    nearest.agent.headState = 'surprise'
    nearest.agent.animations.head.surprise.t = 0
    nearest.agent.target = self
    self.waitingFor = nearest.agent -- le rédacteur va vers la cellule
    nearest.agent:goTo(nearest.neighbor)
  end
end

function World.findNearest(self, cell, agents)
  local candidates = {}
  local neighbor
  local dist
  local minDist = MAX_DIST
  for i, agent in ipairs(agents) do
    if agent.state == 'idle' then -- l'agent est libre
      dist = utils.len(agent.x, agent.y, cell.x, cell.y)
      if dist < MAX_DIST then -- et n'est pas trop loin
        for k = 1, #N, 2 do -- pour chaque case voisine
          neighbor = self:cellAt(cell.x + N[k], cell.y + N[k + 1])
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

return World