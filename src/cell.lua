local Cell = {}
Cell.mt = {__index = Cell}

-- local N = {-1, -1, 0, -1, 1, -1, 1, 0, 1, 1, 0, 1, -1, 1, -1, 0}
local N = {0, -1, 1, 0, 0, 1, -1, 0} -- voisinage accepté
local MAX_DIST = 4 * math.sqrt(2) -- TODO à réduire en fonction du temps qui passe -> plus de mag -> moins de perception

-- TODO passer les mags[] aux cellules et passer les stress[] aux agents

function Cell.Comp(c1, c2)
  return c1.y < c2.y
end

local utils = require 'src.utils'

function Cell.new(x, y, walkable, redacWalkable)
  local new = {
    x = x,
    y = y,
    flyings = nil,
    plane = nil,
    article = nil,
    missed = {}, -- les avions ratés
    explosions = {}, -- les avions en train d'exploser
    walkable = walkable,
    redacWalkable = redacWalkable -- yeurk
    h = utils.ternary(walkable, 0, 10),
    agents = {}, -- normalement qu'un seul devrait suffir... -- on devrait dessiner les agents en dehors pour ne pas avoir à gérer plusieurs agents par cellule
    ox = -.15 + .3 * love.math.random(),
    oy = -.15 + .3 * love.math.random()
  }
  setmetatable(new, Cell.mt)
  return new
end

function Cell.isEmpty(self)
  return not self:hasObject() and #self.agents == 0
end

function Cell.hasObject(self)
  return self.plane or self.article or self.h > 0
end

function Cell.draw(self, gameState)
  for i, agent in ipairs(self.agents) do
    if agent.behind == false then
      agent:draw(gameState)
    end
  end
  if self:hasObject() then
    if gameState.cell and gameState.cell.redacWalkable and gameState.state ~= 'GAME_OVER' and gameState.cell.y < self.y then
      love.graphics.setColor(r, g, b, .2)
    end
    if self.h ~= 0 and self.redacWalkable then
      gameState.data.mags[self.h]:draw(utils.ratio, utils:worldCoordinates(self.x + self.ox, self.y + self.oy)) -- il faudrait avoir cx, cy et x, y (= cx + ox, cy + oy)
    end
    for j, obj in ipairs(cell.objs) do
      obj.quad:draw(utils.ratio, utils:worldCoordinates(self.x + self.ox, self.y + self.oy - self.h * utils.sy))
    end
    if gameState.cell and gameState.cell.y < self.y then
      utils:resetColor()
    end
  end
  for j, flying in ipairs(cell.flying) do
    flying.quad:draw(utils.ratio, utils:worldCoordinates(flying.x, flying.y))
  end
  for i, missed in ipairs(cell.missed) do
    missed:draw(utils.ratio, utils:worldCoordinates(missed.x, missed.y))
  end
  for i, explosion in ipairs(self.explosions) do
    exploding:draw(utils.ratio, utils:worldCoordinates(missed.x, missed.y))
  end
  for i, agent in ipairs(self.agents) do
    if agent.behind then
      agent:draw(gameState)
    end
  end
end

return Cell
