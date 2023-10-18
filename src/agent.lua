local Agent = {}
Agent.mt = {__index = Agent}

local utils = require 'src.utils'
local Path = require 'src.path'

function Agent.new(x, y, tongue, animations, stress)
  local new = {
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
    path = nil,
    animations = animations,
    stress = 0
  }
  new.to = utils.cellAt(new.x, new.y) -- bof
  table.insert(new.to.agents, new) -- bof
  setmetatable(new, Agent.mt)
  return new
end

function Agent.relax(self)
  self.stress = math.min(math.max(0, self.stress - 1), 8)
end

function Agent.getWorried(self)
  self.stress = math.min(math.max(0, self.stress + 1), 8)
end

function Agent.goTo(self, cell)
  self.from = self.to
  utils.remove(self.to.agents, self)
  self.to = cell
  table.insert(self.to.agents, self)
  self.path = Path.new(self.from.x, self.from.y, self.to.x + self.to.ox, self.to.y + self.to.oy)
  self.reverse = (self.to.x + self.to.ox) < self.from.x
  self.behind = (self.to.y + self.to.oy) < self.from.y
end

function Agent.update(self, dt, gameState)
  self.animations.body[self.state]:update(dt)
  self.animations.head[self.headState]:update(dt)
  if self.isAckboo then
    self.animations.item[self.itemState]:update(dt)
  end

  if self.tongue.current then
    self.tongue:update(dt, self.state)
  end

  -- body
  if self.state == 'idle' then
    if self.stress > 7 then
      self.state = 'leaving'
      self.headState = 'cry'
      self.tongue:leaving()
      self.animations.head.cry.t = 0
      self:goTo(gameState.door.cell)
    elseif love.math.random() < .5 * dt and (gameState.state ~= 'IDLE' or not self.isIvan) then
      local candidates = {}
      local origin = utils.cellAt(self.x, self.y)
      local next
      next = utils.cellAt(self.x - 1, self.y)
      if next.walkable and origin.redacWalkable == next.redacWalkable and next:isEmpty() and self.from ~= next then
        table.insert(candidates, next)
      end
      next = utils.cellAt(self.x, self.y - 1)
      if next.walkable and origin.redacWalkable == next.redacWalkable and next:isEmpty() and self.from ~= next then
        table.insert(candidates, next)
      end
      next = utils.cellAt(self.x + 1, self.y)
      if next.walkable and origin.redacWalkable == next.redacWalkable and next:isEmpty() and self.from ~= next then
        table.insert(candidates, next)
      end
      next = utils.cellAt(self.x, self.y + 1)
      if next.walkable and origin.redacWalkable == next.redacWalkable and next:isEmpty() and self.from ~= next then
        table.insert(candidates, next)
      end
      if #candidates > 0 then
        self.state = 'walking'
        self:goTo(candidates[love.math.random(1, #candidates)])
      end
    end
  elseif self.state == 'walking' then
    self.path:update(dt)
    self.x, self.y = self.path:pos()
    if self.path.t == 1 then
      self.state = 'idle'
    end
  elseif self.state == 'leaving' then
    self.path:update(dt)
    self.x, self.y = self.path:pos()
  elseif self.state == 'goingToWork' then -- faire un 'nextState' ou 'todoList'
    self.path:update(dt)
    self.x, self.y = self.path:pos()
    if self.path.t == 1 then
      self.state = 'work'
    end
  elseif self.state == 'work' then
    local objs = self.target.objs
    table.remove(objs, #objs) -- on retire le dernier objet (un avion)
    table.insert(objs, {quad = gameState.data.article})
    gameState:setArticleCount(gameState.articleCount + 1)
    self.target.waitingFor = nil -- le rédacteur a ramasser l'avion
    self.target = nil
    self:getWorried()
    self.state = 'idle'
    if love.math.random() < 10 * dt then
      self.headState = 'speak'
      self.animations.head.speak.t = 0
      self.tongue:work(function() self.headState = 'idle' end)
    end
  end

  -- head
  if self.headState == 'idle' then
    if love.math.random() < .1 * dt then
      self.headState = 'blink'
      self.animations.head.blink.t = 0
    elseif love.math.random() < .025 * dt then
      if self.isAckboo then
        for i, a in ipairs(gameState.agents) do
          if i ~= 0 and a.headState == 'idle' then
            a.headState = utils.ternary(a.isAckboo, 'speak', 'laugh')
            a.animations.head[a.headState].t = 0
          end
        end
        self.tongue:random(function ()
          for i, a in ipairs(gameState.agents) do
            if i ~= 0 and not a.tongue.current then
              a.headState = 'idle'
            end
          end
        end)
      elseif self.isIvan then
        self.headState = 'speak'
        self.animations.head.speak.t = 0
        self.tongue:random(function() self.headState = 'idle' end)
      else
        for i, a in ipairs(gameState.agents) do
          if a.isAckboo or a == self and a.headState == 'idle' then
            a.headState = utils.ternary(a.isAckboo, 'laugh', 'speak')
            a.animations.head[a.headState].t = 0
          end
        end
        self.tongue:random(function ()
          for i, a in ipairs(gameState.agents) do
            if a.isAckboo or a == self and not a.tongue.current then
              a.headState = 'idle'
            end
          end
        end)
      end
    end
  elseif self.headState ~= 'cry' then
    if self.animations.head[self.headState].t == 1 then
      self.headState = 'idle'
    end
  end
end

function Agent.draw(self, gameState) -- dommage le gameState
  local sx, sy = utils:worldCoordinates(self.x, self.y)
  self.animations.body[self.state]:draw(utils.ratio, sx, sy, self.reverse)
  self.animations.head[self.headState]:draw(utils.ratio, sx, sy, self.reverse)
  if self.isAckboo then
    self.animations.item[self.itemState]:draw(utils.ratio, sx, sy, self.reverse)
  end
  if self.stress > 0 then
    gameState.data.stress[self.stress]:draw(utils.ratio, sx, sy)
  end
end

function Agent.drawSpeak(self)
  self.tongue:draw(utils:worldCoordinates(self.x, self.y))
end

return Agent