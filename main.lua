love.graphics.setDefaultFilter('nearest', 'nearest')

-- sprites
local utils = require 'utils'
local loader = require 'loader'
local data = loader(utils)

-- fonts
local fonts = {
  default = love.graphics.newImageFont('assets/fonts/Resource-Imagefont.png',
    " abcdefghijklmnopqrstuvwxyz" ..
    "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
    "123456789.,!?-+/():;%&`'*#=[]\""
  ),
  ackboo = love.graphics.newFont('assets/fonts/comic-sans-ms/ComicSansMS3.ttf'), --, 6 * utils.ratio)
  izual = love.graphics.newFont('assets/fonts/upheaval/upheavtt.ttf', 20 * utils.ratio), --, 6 * utils.ratio)
  sebum = love.graphics.newFont('assets/fonts/alagard.ttf', 24 * utils.ratio)
}
fonts.ivan = fonts.default
fonts.ellen = fonts.default

local texts = {
  start = utils.text.init(fonts.default, "C'est partiiii !"),
  pause = utils.text.init(fonts.default, ""),
  money = utils.text.init(fonts.default, ""),
  article = utils.text.init(fonts.default, ""),
  mag = utils.text.init(fonts.default, ""),
  gameOver = utils.text.init(fonts.default, "GAME OVER"),


  home = utils.text.init(fonts.default, "an Air Pigiste game for the \"Make Something Horrible, l'edition des 20 ans\" by Wolrajhti"),
}

local loadTongues = require 'utils.tongues'
local tongues = loadTongues(fonts)

local ivan = utils.initAgent(2, 7, tongues.ivan, data.ivanAnimations, 0)
ivan.isIvan = true
local ackboo = utils.initAgent(6, 20, tongues.ackboo, data.ackbooAnimations)
ackboo.isAckboo = true
local izual = utils.initAgent(9, 20, tongues.izual, data.izualAnimations)
local sebum = utils.initAgent(12, 20, tongues.sebum, data.sebumAnimations)
local ellen = utils.initAgent(13, 18, tongues.ellen, data.ellenAnimations)

local W, H = love.graphics.getDimensions()
local OX, OY = W / 2, H / 2

utils.ratio = 4 -- ternary(W / H < w / h, W / w, H / h)
utils.cw = 16
utils.ch = 8
utils.sy = .5

local cell
local aiming = false

local gameState = {
  state = 'IDLE',
  texts = texts,
  -- start
  startTimer = 0,
  startOffsetY = 0,
  startOpacity = 1,
  updateStartTimer = function(self, dt)
    self.startTimer = math.min(self.startTimer + dt, 3)
    self.startOffsetY = - self.startTimer / 3 * .5 * OY
    self.startOpacity = 1 - math.min(self.startTimer, 1.2)
  end,
  -- pause
  pauseTimer = 2 * 60 + 55,
  updatePauseTimer = function(self, dt)
    self.pauseTimer = math.max(self.pauseTimer - dt, 0)
    self:setPauseTimer(self.pauseTimer)
    if self.pauseTimer == 0 then
      self.state = 'RUNNING'
    end
  end,
  setPauseTimer = function(self, time)
    self.pauseTimer = time
    self.texts.pause = utils.text.init(fonts.default, os.date("Reprise du direct dans %M:%S", time))
  end,
  -- money
  money = 0,
  setMoney = function(self, sum)
    self.money = math.max(0, sum)
    self.texts.money = utils.text.init(fonts.default, string.format("x%d", math.max(0, sum)), 0)
    if self.money == 0 then
      self:gameOver()
    end
  end,
  magCount = 0,
  setMagCount = function(self, count)
    self.magCount = count
    self.texts.mag = utils.text.init(fonts.default, string.format("numero %03d", count), 0)
  end,
  -- article
  articleCount = 0,
  articleTodoCount = 10,
  setArticleCount = function(self, count)
    self.articleCount = count
    self.texts.article = utils.text.init(fonts.default, string.format("%d/%d", count, self.articleTodoCount))
  end,
  setArticleTodoCount = function(self, countTodo)
    self.articleTodoCount = countTodo
    self.texts.article = utils.text.init(fonts.default, string.format("%d/%d", self.articleCount, countTodo))
  end,
  -- gameOver
  gameOver = function(self)
    self.state = 'GAME_OVER'
  end,
  -- à cleaner
  DEBUG_T = nil,
  data = data, -- contient les images, quads et animations
  AIMING_WINDOW = 6, -- temps laissé au joueur pour viser
  PX1 = -2, PY1 = 15, -- départ des avions
  FLYING_SPEED_MIN = 10, -- vitesse des avions (variable ?)
  FLYING_SPEED_MAX = 30, -- vitesse des avions (variable ?)
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
    if self.state ~= 'PAUSE' then
      self.cell = utils.cellAt(utils.cellCoordinates(x, y))
      self.aimingObs = utils.heightThreshold(self.cell) -- TODO à maj en temps réel
    end
  end,
  update = function(self, dt)
    if self.state ~= 'PAUSE' then
      if self.state == 'RUNNING' then
        if self.startTimer < 2 then
          self:updateStartTimer(dt)
        end
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
          end
          if self.endOfTheMonth then
            local candidates = {}
            local needsUpdate = false
            for i, cell in ipairs(utils.orderedCells) do
              if cell.redacWalkable and #cell.objs ~= 0 then
                needsUpdate = needsUpdate or self.cell and cell.y == self.cell.y
                if cell.waitingFor == nil then -- s'il y a un objet et que waitingFor est nil => c'est un article !
                  table.insert(candidates, cell)
                else
                  local p = table.remove(cell.objs, #cell.objs)
                  p.exploding = false
                  p.update = utils.updatePlane
                  p.animations = {exploding = utils.copyAnimation(self.data.exploding)}
                  p.animations.exploding.t = 0
                  table.insert(cell.missed, p)
                end
              end
            end
            if #candidates >= self.articleTodoCount then
              for i, cell in ipairs(candidates) do
                cell.h = math.min(cell.h + 1, 10)
                self:setMoney(self.money + 2)
                table.remove(cell.objs, #cell.objs)
              end
              self:setArticleCount(0)
              self:setMagCount(self.magCount + 1)
              if #candidates > self.articleTodoCount + 1 then -- si trop de production => le patronnat prend ça pour acquis
                self:setArticleTodoCount(self.articleTodoCount + 1)
              end
            end
            if needsUpdate then
              self.aimingObs = utils.heightThreshold(self.cell)
            end
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
          if #self.agents == 0 then
            self:gameOver()
          end
        end
      end

      self.data.logos:update(dt)
      self.data.waves:update(dt)
      -- self.data.clouds:update(dt)

      utils.updateCells(dt, self)
    else
      self:updatePauseTimer(dt)
    end
  end,
  aim = function(self)
    if ivan.state ~= 'walking' and self.cell.redacWalkable and self.state ~= 'GAME_OVER' then
      self.aiming = true
      ivan.state = 'aiming'
      ivan.reverse = false
      self.aimingSpeed = 2 -- + .05 * self.cell.x pas besoin de faire du variable
      self.t = 2 * love.math.random()
      self.t0 = self.t
    end
  end,
  throw = function(self)
    if self.state == 'IDLE' then
      self.state = 'RUNNING'
    end
    self.aimingObs = utils.heightThreshold(self.cell)
    ivan.state = 'idle'
    ivan.tongue:aim()
    local h = - utils.round(self.offset) -- entre 0 et 10
    -- print('h = '..h..'('..self.cell.y..' - '..utils.round(self.y)..') raw y = '.. self.y)
    local p = {
      x1 = self.PX1,
      y1 = self.PY1,
      speed = love.math.random(self.FLYING_SPEED_MIN, self.FLYING_SPEED_MAX),
    }
    -- il faut rappeler heightThreshold pour être sur d'avoir la donnée à jour
    -- print('OBS', self.aimingObs[h].cell.x .. ', ' .. self.aimingObs[h].cell.y, 'DEBUG-T = ' ..self.DEBUG_T)
    p.x2 = self.aimingObs[h].cell.x + self.aimingObs[h].cell.ox
    p.y2 = self.cell.y - self.aimingObs[h].h + self.aimingObs[h].cell.oy
    if self.aimingObs[h].onTop then
      if self.aimingObs[h].cell == self.cell then
        -- perfect shot !
        self:setMoney(self.money + 1)
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
    self:setMoney(self.money - 1)
  end
}

gameState:setMoney(100)
gameState:setArticleCount(0)
gameState:setArticleTodoCount(5)
gameState:setMagCount(0)

function love.update(dt)
  gameState:update(dt)
end

love.graphics.setLineStyle('rough')
love.graphics.setLineWidth(utils.ratio)
love.graphics.setFont(fonts.default)

function love.draw()
  love.graphics.setColor(1, 1, 1)

  utils.drawImage(gameState.data.background, OX, OY)
  utils.drawQuad(gameState.data.logos, OX, OY)
  utils.drawQuad(gameState.data.waves, OX, OY)
  -- utils.drawQuad(gameState.data.clouds, OX, OY)

  if #gameState.door.cell.agents ~= 0 then
    utils.drawImage(gameState.data.door, OX, OY)
  end

  utils.drawCalendar(gameState)

  if gameState.state ~= 'IDLE' then
    utils.text.draw(gameState.texts.article, utils.worldCoordinates(7, 14))
  end
  -- utils.drawWalkingAreas()

  if gameState.cell and gameState.cell.redacWalkable and gameState.state ~= 'GAME_OVER' then
    utils.drawLine(utils.lineAt(gameState.cell.y))
  end

  utils.drawCells(gameState)

  if ivan.state ~= 'walking' and gameState.cell and gameState.cell.redacWalkable and gameState.state ~= 'GAME_OVER' then
    utils.drawQuad(gameState.data.cursor, utils.worldCoordinates(gameState.cell.x, gameState.cell.y))
    if gameState.state ~= 'IDLE' or gameState.aiming then
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
  end

  utils.drawImage(gameState.data.foreground, OX, OY)

  if gameState.state ~= 'IDLE' then
    if gameState.money > 0 then
      local dx, dy = utils.worldCoordinates(4, 1)
      utils.drawQuad(gameState.data.dollarStart, dx, dy)
      for i = 0, math.min(200, gameState.money) - 1 do
        utils.drawQuad(gameState.data.dollarStack[(i - 1 + (gameState.money % #gameState.data.dollarStack)) % #gameState.data.dollarStack + 1], dx + (i + 1) * utils.ratio, dy)
      end
      utils.drawQuad(gameState.data.dollarEnd, dx + (math.min(200, gameState.money) - 1) * utils.ratio, dy)
    end

    utils.text.draw(gameState.texts.money, utils.worldCoordinates(5, 1.5))
    utils.text.draw(gameState.texts.mag, utils.worldCoordinates(5, 2.5))
  end

  if gameState.state == 'PAUSE' then
    utils.text.drawTitle(gameState.texts.pause, OX, OY)
  elseif gameState.state == 'RUNNING' then
    if gameState.startTimer < 3 then
      love.graphics.setColor(1, 1, 1, gameState.startOpacity)
      utils.text.drawTitle(gameState.texts.start, OX, OY + gameState.startOffsetY)
    end
  elseif gameState.state == 'GAME_OVER' then
    utils.text.drawTitle(gameState.texts.gameOver, OX, OY)
  elseif gameState.state == 'IDLE' then
    utils.text.drawSmall(gameState.texts.home, utils.worldCoordinates(10, 24))
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
  if key == 'escape' then
    love.event.quit()
  elseif key == 'space' then
    gameState.state = utils.ternary(gameState.state == 'PAUSE', 'RUNNING', 'PAUSE') -- faire une pause de 3 min max comme dans l'emission
    gameState:setPauseTimer(2 * 60 + 56)
  end
end

-- function love.resize(w, h)
--   W, H = w, h
--   OX, OY = W / 2, H / 2
-- end