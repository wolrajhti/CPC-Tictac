love.window.setFullscreen(true)
love.graphics.setDefaultFilter('nearest', 'nearest')

-- sprites
local utils = require 'src.utils'
local loader = require 'src.loader'
local Agent = require 'src.agent'
local Plane = require 'src.plane'

local data = loader.load()

utils:setBackgroundImage(data.background)
utils:setSize(love.graphics.getDimensions())

local ivan = Agent.new(2, 7, data.ivanSpeaks, data.ivanAnimations)
ivan.isIvan = true
local ackboo = Agent.new(6, 20, data.ackbooSpeaks, data.ackbooAnimations)
ackboo.isAckboo = true
local izual = Agent.new(9, 20, data.izualSpeaks, data.izualAnimations)
local sebum = Agent.new(12, 20, data.sebumSpeaks, data.sebumAnimations)
local ellen = Agent.new(13, 18, data.ellenSpeaks, data.ellenAnimations)

local world = World.new({
  -- ivan
  {x = 1, y = 2, w = 1, h = 6},
  {x = 2, y = 3, w = 1, h = 5},
  {x = 3, y = 5, w = 1, h = 2},
  -- door
  {x = 13, y = 17, w = 1, h = 1}
}, {
  -- redac
  {x = 3, y = 18, w = 15, h = 3},
  {x = 2, y = 21, w = 17, h = 2},
  {x = 1, y = 23, w = 19, h = 2},
})

local cell
local aiming = false

local gameState = {
  state = 'IDLE',
  quotes = data.quotes.default,
  -- start
  startTimer = 0,
  startOffsetY = 0,
  startOpacity = 1,
  updateStartTimer = function(self, dt)
    self.startTimer = math.min(self.startTimer + dt, 3)
    self.startOffsetY = - self.startTimer / 3 * .5 * utils.OY
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
    self.quotes.pause:set(os.date("Reprise du direct dans %M:%S", time))
  end,
  -- money
  money = 0,
  setMoney = function(self, sum)
    self.money = math.max(0, sum)
    self.quotes.money:set(string.format("x%d", math.max(0, sum)), 0)
    if self.money == 0 then
      self:gameOver()
    end
  end,
  magCount = 0,
  setMagCount = function(self, count)
    self.magCount = count
    self.quotes.mag:set(string.format("numero %03d", count), 0)
  end,
  -- article
  articleCount = 0,
  articleTodoCount = 10,
  setArticleCount = function(self, count)
    self.articleCount = count
    self.quotes.article:set(string.format("%d/%d", count, self.articleTodoCount))
  end,
  setArticleTodoCount = function(self, countTodo)
    self.articleTodoCount = countTodo
    self.quotes.article:set(string.format("%d/%d", self.articleCount, countTodo))
  end,
  -- gameOver
  gameOver = function(self)
    self.state = 'GAME_OVER'
  end,
  data = data, -- contient les images, quads et animations
  AIMING_WINDOW = 6, -- temps laissé au joueur pour viser
  cell, -- case survolée
  aiming, -- bool
  aimingSpeed, -- vitesse de déplacement du viseur
  t0, t, -- date de début de la visé et date actuelle
  offset = 0, -- position du viseur
  calendar = Calendar.new(2, {
                            {131, 110}, {133, 110}, {135, 110}, {137, 110}, {139, 110},
    {127, 112}, {129, 112}, {131, 112}, {133, 112}, {135, 112}, {137, 112}, {139, 112},
    {127, 114}, {129, 114}, {131, 114}, {133, 114}, {135, 114}, {137, 114}, {139, 114},
    {127, 116}, {129, 116}, {131, 116}, {133, 116}, {135, 116}, {137, 116}, {139, 116},
    {127, 118}, {129, 118}, {131, 118}, {133, 118}
  }),
  agents = {ivan, ackboo, izual, sebum, ellen},
  door = {image = door, cell = utils.cellAt(13, 17)},
  aimingObs = {},
  updateCell = function(self, x, y)
    if self.state ~= 'PAUSE' then
      self.cell = utils.cellAt(utils:cellCoordinates(x, y))
      self.aimingObs = utils.heightThreshold(self.cell) -- TODO à maj en temps réel
    end
  end,
  update = function(self, dt)
    if self.state ~= 'PAUSE' then
      if self.state == 'RUNNING' then
        if self.startTimer < 2 then
          self:updateStartTimer(dt)
        end
        for i, event in ipairs(self.calendar:update(dt)) do
          if event == 'weekend' then
            for i, agent in ipairs(self.agents) do
              if i ~= 1 and agent.state ~= 'leaving' then -- ivan (bof bof ...)
                agent:relax()
              end
            end
          elseif event == 'endOfTheMonth' then
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
                  p.animations = {exploding = self.data.exploding:copy()}
                  p.animations.exploding.t = 0
                  table.insert(cell.missed, p)
                end
              end
            end
            if #candidates >= self.articleTodoCount then
              -- s'il y a assez d'article pour faire un magasine on converti au hasard le nombre d'article attendu
              utils.shuffle(candidates)
              for i = 1, self.articleTodoCount do
                local cell = table.remove(candidates);
                cell.h = math.min(cell.h + 1, 10)
                self:setMoney(self.money + 2) -- chaque article rapporte 2 billets
                table.remove(cell.objs, #cell.objs)
              end
              self:setArticleCount(self.articleCount - self.articleTodoCount)
              self:setMagCount(self.magCount + 1)
              if #candidates > 0 then
                -- si trop de production => le patronnat prend ça pour acquis
                self:setArticleTodoCount(self.articleTodoCount + #candidates)
              end
            else
              -- si aucun magasine n'est produit dans le mois, ça stresse les rédacteurs
              for i, agent in ipairs(self.agents) do
                if i ~= 1 then
                  agent:getWorried()
                end
              end
            end
            -- on perd 1 par article fait non transformé
            self:setMoney(self.money - #candidates)
            if needsUpdate then
              self.aimingObs = utils.heightThreshold(self.cell)
            end
          end
        end
      end

      if self.aiming then
        self.t = self.t + self.aimingSpeed * dt
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
          if #self.agents == 1 then
            self:gameOver()
          end
        end
      end

      self.data.logos:update(dt)
      self.data.waves:update(dt)

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
    if love.math.random() < .2 then
      ivan.tongue:aim()
    end
    local h = - utils.round(self.offset) -- entre 0 et 10
    -- il faut rappeler heightThreshold pour être sur d'avoir la donnée à jour
    local p = Plane.new(
      self.data.plane,
      self.data.exploding, -- le copy devrait être ici ?
      self.aimingObs[h].cell.x + self.aimingObs[h].cell.ox,
      self.cell.y - self.aimingObs[h].h + self.aimingObs[h].cell.oy
    )
    if self.aimingObs[h].onTop then
      if self.aimingObs[h].cell == self.cell then
        -- perfect shot !
        self:setMoney(self.money + 1)
      end
      table.insert(self.aimingObs[h].cell.flying, p)
    else
      p:miss(self.aimingObs[h].cell)
    end
    self.aiming = false
    self:setMoney(self.money - 1)
  end
}

gameState.door.cell.ox, gameState.door.cell.oy = .5, 0
gameState:setMoney(100)
gameState:setArticleCount(0)
gameState:setArticleTodoCount(5)
gameState:setMagCount(0)

function love.update(dt)
  gameState:update(dt)
end

love.graphics.setLineStyle('rough')
love.graphics.setLineWidth(utils.ratio)
love.graphics.setFont(data.fonts.default)

function love.draw()
  love.graphics.setColor(1, 1, 1)

  gameState.data.background:draw(utils.ratio, utils.OX, utils.OY)
  gameState.data.logos:draw(utils.ratio, utils.OX, utils.OY)
  gameState.data.waves:draw(utils.ratio, utils.OX, utils.OY)

  if #gameState.door.cell.agents ~= 0 then
    gameState.data.door:draw(utils.ratio, utils.OX, utils.OY)
  end

  utils.drawCalendar(gameState)

  if gameState.state ~= 'IDLE' then
    gameState.quotes.article:draw(utils:worldCoordinates(7, 14))
  end
  -- utils.drawWalkingAreas()

  if gameState.cell and gameState.cell.redacWalkable and gameState.state ~= 'GAME_OVER' then
    world:drawLineAt(gameState.cell)
  end

  utils.drawCells(gameState)

  gameState.data.foreground:draw(utils.ratio, utils.OX, utils.OY)

  if gameState.state ~= 'IDLE' then
    if gameState.money > 0 then
      local dx, dy = utils:worldCoordinates(4, 1)
      gameState.data.dollarStart:draw(utils.ratio, dx, dy)
      for i = 0, math.min(200, gameState.money) - 1 do
        gameState.data.dollarStack[(i - 1 + (gameState.money % #gameState.data.dollarStack)) % #gameState.data.dollarStack + 1]:draw(utils.ratio, dx + (i + 1) * utils.ratio, dy)
      end
      gameState.data.dollarEnd:draw(utils.ratio, dx + (math.min(200, gameState.money) - 1) * utils.ratio, dy)
    end

    gameState.quotes.money:draw(utils:worldCoordinates(5, 1.5))
    gameState.quotes.mag:draw(utils:worldCoordinates(5, 2.5))
  end

  utils.drawSpeaks(gameState)

  if ivan.state ~= 'walking' and gameState.cell and gameState.cell.redacWalkable and gameState.state ~= 'GAME_OVER' then
    gameState.data.cursor:draw(utils.ratio, utils:worldCoordinates(gameState.cell.x, gameState.cell.y))
    if gameState.state ~= 'IDLE' or gameState.aiming then
      gameState.data.ruler:draw(utils.ratio, utils:worldCoordinates(gameState.cell.x + gameState.cell.ox, gameState.cell.y + gameState.cell.oy))
      love.graphics.setColor(251 / 255, 242 / 255, 54 / 255)
      for i = 9, 0, -1 do
        if gameState.aimingObs[i].onTop == true then -- à ajuster
          gameState.data.tick:draw(utils.ratio, utils:worldCoordinates(gameState.cell.x + gameState.cell.ox, gameState.cell.y + gameState.cell.oy - i * utils.sy))
        end
      end
      love.graphics.setColor(1, 1, 1)
      if gameState.aiming then
        gameState.data.target:draw(utils.ratio, utils:worldCoordinates(gameState.cell.x + gameState.cell.ox, gameState.cell.y + gameState.cell.oy + gameState.offset * utils.sy))
      end
    end
  end

  if gameState.state == 'PAUSE' then
    gameState.quotes.pause:drawTitle(utils.OX, utils.OY)
  elseif gameState.state == 'RUNNING' then
    if gameState.startTimer < 3 then
      love.graphics.setColor(1, 1, 1, gameState.startOpacity)
      gameState.quotes.start:drawTitle(utils.OX, utils.OY + gameState.startOffsetY)
    end
  elseif gameState.state == 'GAME_OVER' then
    gameState.quotes.gameOver:drawTitle(utils.OX, utils.OY)
  elseif gameState.state == 'IDLE' then
    gameState.quotes.home:drawSmall(utils:worldCoordinates(10, 24))
  end
end

function love.mousemoved(x, y)
  if not gameState.aiming then
    gameState:updateCell(x, y)
  end
end

function love.mousepressed(x, y, button)
  if button == 1 and gameState.state ~= 'PAUSE' then
    gameState:aim()
  end
end

function love.mousereleased(x, y, button)
  if button == 1 and gameState.state ~= 'PAUSE' and gameState.aiming then
    gameState:throw()
  end
end

function love.keypressed(key)
  if key == 'escape' then
    if love.window.getFullscreen() then
      if gameState.state == 'RUNNING' then
        gameState.state = 'PAUSE'
      end
      love.window.setFullscreen(false)
      utils:setSize(love.graphics.getDimensions())
    else
      love.event.quit()
    end
  elseif key == 'space' then
    if gameState.state == 'RUNNING' then
      gameState.state = 'PAUSE' -- faire une pause de 3 min max comme dans l'emission
      gameState:setPauseTimer(2 * 60 + 56)
    elseif gameState.state == 'PAUSE' then
      gameState.state = 'RUNNING'
      if gameState.aiming then
        gameState:throw()
      end
    end
  end
end

function love.resize(w, h)
  utils:setSize(w, h)
end