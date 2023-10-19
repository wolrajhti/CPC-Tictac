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
    flying = {}, -- les avions en train d'arriver
    explosions = {}, -- les avions rater sont remplacés par des explosions
    obj = nil, -- plane ou article
    walkable = walkable,
    redacWalkable = redacWalkable, -- yeurk
    h = utils.ternary(walkable, 0, 10),
    agent = nil,
    ox = -.15 + .3 * love.math.random(),
    oy = -.15 + .3 * love.math.random()
  }
  new.cx, new.cy = new.x + new.ox, new.y + new.oy
  setmetatable(new, Cell.mt)
  return new
end

function Cell.isEmpty(self)
  return not self.obj and self.h == 0 and not self.agent
end

function Cell.draw(self, gameState)
  if self.agent and self.agent.behind == false then
    self.agent:draw(gameState)
  end
  if gameState.cell and gameState.cell.redacWalkable and gameState.state ~= 'GAME_OVER' and gameState.cell.y < self.y then -- TODO CLEAN
    utils:setOpacity(.2)
  end
  if self.h ~= 0 and self.redacWalkable then
    gameState.data.mags[self.h]:draw(utils.ratio, utils:worldCoordinates(self.cx, self.cy))
  end
  if self.obj then
    gameState.data[self.obj]:draw(utils.ratio, utils:worldCoordinates(self.cx, self.cy - self.h * utils.sy))
  end
  if gameState.cell and gameState.cell.redacWalkable and gameState.state ~= 'GAME_OVER' and gameState.cell.y < self.y then -- TODO CLEAN
    utils:resetColor()
  end
  for i, flying in ipairs(self.flying) do
    flying.quad:draw(utils.ratio, utils:worldCoordinates(flying.x, flying.y))
  end
  for i, explosion in ipairs(self.explosions) do
    exploding:draw(utils.ratio, utils:worldCoordinates(self.cx, self.cy))
  end
  if self.agent and self.agent.behind then
    self.agent:draw(gameState)
  end
end

return Cell
