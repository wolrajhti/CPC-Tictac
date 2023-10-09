love.graphics.setDefaultFilter('nearest', 'nearest')

-- sprites
local utils = require 'utils'
local loader = require 'loader'
local data = loader(utils)

local ivan = utils.initAgent(2, 7, data.ivanAnimations, 0)
local ackboo = utils.initAgent(6, 20, data.ackbooAnimations)
local izual = utils.initAgent(9, 20, data.izualAnimations)
local sebum = utils.initAgent(12, 20, data.sebumAnimations)
local ellen = utils.initAgent(15, 20, data.ellenAnimations)

local W, H = love.graphics.getDimensions()
local OX, OY = W / 2, H / 2

utils.ratio = 4 -- ternary(W / H < w / h, W / w, H / h)
utils.cw = 16
utils.ch = 8
utils.sy = .5

-- fonts
local fonts = {
  default = love.graphics.newImageFont('assets/fonts/Resource-Imagefont.png',
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\""
  ),
  -- ackboo = love.graphics.newFont('assets/fonts/comic-sans-ms/ComicSansMS3.ttf', 6 * utils.ratio),
  -- izual = love.graphics.newFont('assets/fonts/CT ProLamina.ttf', 9 * utils.ratio),
  -- sebum = love.graphics.newFont('assets/fonts/exmouth/exmouth_.ttf', 8 * utils.ratio),
  -- ellen = love.graphics.newFont('assets/fonts/mortified_drip/MortifiedDrip.ttf', 7 * utils.ratio)
}

local texts = {
  -- ackboo = {
  --   test = {
  --     utils.initText(fonts.default, 'Bonsoir les frerots frerottes')
  --   },
  --   pense = {}
  -- },
  -- izual = {
  --   test = {
  --     utils.initText(fonts.default, 'Bonsoir les frerots frerottes')
  --   },
  --   pense = {}
  -- },
  -- sebum = {
  --   test = {
  --     utils.initText(fonts.default, 'Bonsoir les frerots frerottes')
  --   },
  --   pense = {}
  -- },
  -- ellen = {
  --   test = {
  --     utils.initText(fonts.default, 'Bonsoir les frerots frerottes')
  --   },
  --   pense = {}
  -- }
}

local cell
local aiming = false

local gameState = {
  money = 50,
  magCount = 0,
  articleCount = 0,
  DEBUG_T = nil,
  data = data, -- contient les images, quads et animations
  AIMING_WINDOW = 6, -- temps laissé au joueur pour viser
  PX1 = -2, PY1 = 15, -- départ des avions
  FLYING_SPEED = 30, -- vitesse des avions (variable ?)
  cell, -- case survolée
  aiming, -- bool
  aimingSpeed, -- vitesse de déplacement du viseur
  t0, t, -- date de début de la visé et date actuelle
  offset = 0, -- position du viseur
  day = 1,
  time = 0,
  TIME_SPEED = 2, -- à ajuster
  CALENDAR_X = 131,
  CALENDAR_Y = 110,
  CALENDAR_CELLS = {
                            {131, 110}, {133, 110}, {135, 110}, {137, 110}, {139, 110},
    {127, 112}, {129, 112}, {131, 112}, {133, 112}, {135, 112}, {137, 112}, {139, 112},
    {127, 114}, {129, 114}, {131, 114}, {133, 114}, {135, 114}, {137, 114}, {139, 114},
    {127, 116}, {129, 116}, {131, 116}, {133, 116}, {135, 116}, {137, 116}, {139, 116},
    {127, 118}, {129, 118}, {131, 118}, {133, 118}
  },
  agents = {ivan, ackboo, izual, sebum, ellen},
  door = {image = door, cell = utils.cellAt(13, 17), ox = .5},
  OX = OX,
  OY = OY,
  aimingObs = {},
  updateCell = function(self, x, y)
    self.cell = utils.cellAt(utils.cellCoordinates(x, y))
    self.aimingObs = utils.heightThreshold(self.cell) -- TODO à maj en temps réel
  end,
  update = function(self, dt)
    self.time = self.time + self.TIME_SPEED * dt
    while self.time > 1 do
      self.time = self.time - 1
      self.day = self.day + 1
      if self.day > 30 then
        self.day = self.day - 30
      end
      self.endOfTheMonth = self.day == 30
      self.weekend = self.day == 6 or-- self.day == 7 or
                     self.day == 13 or-- self.day == 14 or
                     self.day == 20 or-- self.day == 21 or
                     self.day == 27-- or self.day == 28
      if self.weekend then
        for i, agent in ipairs(self.agents) do
          if i ~= 1 and agent.state ~= 'leaving' then -- ivan (bof bof ...)
            agent.stress = math.min(math.max(0, agent.stress - 1), 8)
          end
        end
      -- end
      -- if self.endOfTheMonth then
        local needsUpdate = false
        for i, cell in ipairs(utils.orderedCells) do
          if cell.redacWalkable and #cell.objs ~= 0 then
            needsUpdate = needsUpdate or self.cell and cell.y == self.cell.y
            table.remove(cell.objs, #cell.objs)
            if cell.waitingFor == nil then -- s'il y a un objet et que waitingFor est nil => c'est un article !
              cell.h = math.min(cell.h + 1, 10)
              self.money = self.money + 2
            end
          end
        end
        if needsUpdate then
          self.aimingObs = utils.heightThreshold(self.cell)
        end
      end
    end
    if self.aiming then
      self.t = self.DEBUG_T or (self.t + self.aimingSpeed * dt)
      local u = self.t % 2
      if u > 1 then
        self.offset = -10 * (2 - u)
      else
        self.offset = -10 * u
      end
      -- print('cell.y = '..self.cell.y.. ', offset = '.. offset)
      if self.t > self.t0 + 6 then
        self:throw()
      end
    end
    for i = #self.agents, 1, -1 do
      self.agents[i]:update(dt, self)
      if self.agents[i].state == 'leaving' and self.agents[i].t == 1 then
        utils.remove(self.agents[i].to.agents, self.agents[i])
        table.remove(self.agents, i)
      end
    end
  end,
  aim = function(self)
    if self.cell.redacWalkable then
      self.aiming = true
      ivan.state = 'aiming'
      ivan.reverse = false
      self.aimingSpeed = 2 -- + .05 * self.cell.x pas besoin de faire du variable
      self.t = 2 * love.math.random()
      self.t0 = self.t
    end
  end,
  throw = function(self)
    self.aimingObs = utils.heightThreshold(self.cell)
    ivan.state = 'idle'
    local h = - utils.round(self.offset) -- entre 0 et 10
    -- print('h = '..h..'('..self.cell.y..' - '..utils.round(self.y)..') raw y = '.. self.y)
    local p = {
      x1 = self.PX1,
      y1 = self.PY1,
      speed = self.FLYING_SPEED,
    }
    -- il faut rappeler heightThreshold pour être sur d'avoir la donnée à jour
    -- print('OBS', self.aimingObs[h].cell.x .. ', ' .. self.aimingObs[h].cell.y, 'DEBUG-T = ' ..self.DEBUG_T)
    p.x2 = self.aimingObs[h].cell.x + self.aimingObs[h].cell.ox
    p.y2 = self.cell.y - self.aimingObs[h].h + self.aimingObs[h].cell.oy
    if self.aimingObs[h].onTop then
      if self.aimingObs[h].cell == self.cell then
        -- perfect shot !
        self.money = self.money + 1
      end
      table.insert(self.aimingObs[h].cell.flying, p)
    else
      p.exploding = false
      p.animations = {exploding = utils.copyAnimation(self.data.exploding)}
      p.animations.exploding.t = 0
      table.insert(self.aimingObs[h].cell.missed, p)
    end
    p.len = utils.len(p.x1, p.y1, p.x2, p.y2)
    p.x, p.y = p.x1, p.y1
    p.t = 0
    p.quad = self.data.plane
    p.update = utils.updatePlane
    self.aiming = false
    self.money = self.money - 1
  end
}

function love.update(dt)
  gameState:update(dt)
  gameState.data.logos:update(dt)
  gameState.data.waves:update(dt)
  gameState.data.clouds:update(dt)
  utils.updateCells(dt, gameState)
end

love.graphics.setLineStyle('rough')
love.graphics.setLineWidth(utils.ratio)
love.graphics.setFont(fonts.default)

function love.draw()
  love.graphics.setColor(1, 1, 1)

  utils.drawImage(gameState.data.background, OX, OY)
  utils.drawQuad(gameState.data.logos, OX, OY)
  utils.drawQuad(gameState.data.waves, OX, OY)
  utils.drawQuad(gameState.data.clouds, OX, OY)

  if #gameState.door.cell.agents ~= 0 then
    utils.drawImage(gameState.data.door, OX, OY)
  end

  utils.drawCalendar(gameState)
  -- utils.drawWalkingAreas()

  if gameState.cell and gameState.cell.redacWalkable then
    utils.drawLine(utils.lineAt(gameState.cell.y))
  end

  utils.drawCells(gameState)

  if gameState.cell and gameState.cell.redacWalkable then
    utils.drawQuad(gameState.data.cursor, utils.worldCoordinates(gameState.cell.x, gameState.cell.y))
    utils.drawQuad(gameState.data.ruler, utils.worldCoordinates(gameState.cell.x + gameState.cell.ox, gameState.cell.y + gameState.cell.oy))
    love.graphics.setColor(251 / 255, 242 / 255, 54 / 255)
    for i = 9, 0, -1 do
      if gameState.aimingObs[i].onTop == true then -- à ajuster
      --   love.graphics.setColor(233 / 255, 54 / 255, 54 / 255)
      -- else
      --   love.graphics.setColor(251 / 255, 242 / 255, 54 / 255)
        utils.drawQuad(gameState.data.tick, utils.worldCoordinates(gameState.cell.x + gameState.cell.ox, gameState.cell.y + gameState.cell.oy - i * utils.sy))
      end
    end
    love.graphics.setColor(1, 1, 1)
    -- utils.drawQuad(goal, utils.worldCoordinates(gameState.cell.x, gameState.cell.y - gameState.cell.h))
    if gameState.aiming then
      utils.drawQuad(gameState.data.target, utils.worldCoordinates(gameState.cell.x + gameState.cell.ox, gameState.cell.y + gameState.cell.oy + gameState.offset * utils.sy))
    end
  end

  -- utils.drawText(texts.ackboo.test[1], utils.worldCoordinates(PATH.at(P)))
  -- utils.drawText(texts.izual.test[1], utils.worldCoordinates(5, 40))
  -- utils.drawText(texts.sebum.test[1], sx, sy)
  -- utils.drawText(texts.ellen.test[1], utils.worldCoordinates(15, 40))
  utils.drawImage(gameState.data.foreground, OX, OY)

  utils.getColor()
  -- love.graphics.setColor(0, 0, 0)
  love.graphics.print(love.timer.getFPS(), 64, 64)
  love.graphics.print('money = '.. gameState.money, 128, 64)
  -- love.graphics.print(gameState.y, 64, 84)
  -- local i = 0
  -- for k, v in pairs(gameState.aimingObs) do
  --   love.graphics.print(k..'='..utils.ternary(v, 'true', 'false'), 256, 32 + i * 20)
  --   i = i + 1
  -- end
  -- love.graphics.print(gameState.DEBUG_T, 400, 64)

  utils.setColor()

  if gameState.money > 0 then
    local dx, dy = utils.worldCoordinates(2.5, 1)
    utils.drawQuad(gameState.data.dollarStart, dx, dy)
    for i = 0, math.min(200, gameState.money) do --math.ceil(gameState.money / 5) do
    -- for i = 0, math.ceil(gameState.money / 5) do
      utils.drawQuad(gameState.data.dollarStack[i % #gameState.data.dollarStack + 1], dx + (i + 1) * utils.ratio, dy)
    end
    utils.drawQuad(gameState.data.dollarEnd, dx + (math.min(200, gameState.money) + 1) * utils.ratio, dy)
    -- utils.drawQuad(dollarEnd, dx + (math.ceil(gameState.money / 5) + 1) * utils.ratio, dy)
  end
end

function love.mousemoved(x, y)
  if not gameState.aiming then
    gameState:updateCell(x, y)
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    gameState:aim()
  end
end

function love.mousereleased(x, y, button)
  if button == 1 and gameState.aiming then
    gameState:throw()
  end
end

function love.keypressed(key)
  if key == '1' then
    gameState.DEBUG_T = 0
  elseif key == '2' then
    gameState.DEBUG_T = 0.1
  elseif key == '3' then
    gameState.DEBUG_T = 0.2
  elseif key == '4' then
    gameState.DEBUG_T = 0.3
  elseif key == '5' then
    gameState.DEBUG_T = 0.4
  elseif key == '6' then
    gameState.DEBUG_T = 0.5
  elseif key == '7' then
    gameState.DEBUG_T = 0.6
  elseif key == '8' then
    gameState.DEBUG_T = 0.7
  elseif key == '9' then
    gameState.DEBUG_T = 0.8
  elseif key == '0' then
    gameState.DEBUG_T = 0.9
  elseif key == ')' then
    gameState.DEBUG_T = nil
  end
end

-- function love.resize(w, h)
--   W, H = w, h
--   OX, OY = W / 2, H / 2
-- end