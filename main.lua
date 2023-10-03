love.graphics.setDefaultFilter('nearest', 'nearest')

-- sprites
local utils = require 'utils'

local background = utils.initImage('assets/sprites/full_scene_2.png')
local cursor = utils.initImage('assets/sprites/cursor.png')
local texture = love.graphics.newImage('assets/sprites/aim_system.png')
local ruler = utils.initQuad(texture, 1, 1, 6, 46, nil, 43)
local tick = utils.initQuad(texture, 10, 2, 4, 8, nil, 6)
local goal = utils.initQuad(texture, 8, 12, 8, 8)
local target = utils.initQuad(texture, 17, 17, 14, 14)
local plane = utils.initQuad(texture, 20, 39, 9, 5)
local bookTexture = love.graphics.newImage('assets/sprites/books_2.png')
local test = utils.initQuad(bookTexture, 0, 7, 11, 6)
local mag = utils.initQuad(bookTexture, 10, 4, 11, 9)
local pile = utils.initQuad(bookTexture, 20, 0, 11, 13)

local ivan = {
  x = 6,
  y = 20,
  state = 'idle',
  reverse = math.random() < .5,
  t = 0,
  path = nil,
  animations = {}
}

local ackboo = {
  x = 6,
  y = 40,
  state = 'idle',
  reverse = math.random() < .5,
  t = 0,
  path = nil,
  animations = {}
}

local izual = {
  x = 9,
  y = 40,
  state = 'idle',
  reverse = math.random() < .5,
  t = 0,
  path = nil,
  animations = {}
}

local sebum = {
  x = 12,
  y = 40,
  state = 'idle',
  reverse = math.random() < .5,
  t = 0,
  path = nil,
  animations = {}
}

local ellen = {
  x = 15,
  y = 40,
  state = 'idle',
  reverse = math.random() < .5,
  t = 0,
  path = nil,
  animations = {}
}

local characters = {
  love.graphics.newImage('assets/sprites/cpc_assets1.png'),
  love.graphics.newImage('assets/sprites/cpc_assets2.png'),
  love.graphics.newImage('assets/sprites/cpc_assets3.png'),
  love.graphics.newImage('assets/sprites/cpc_assets4.png'),
  love.graphics.newImage('assets/sprites/cpc_assets5.png'),
  love.graphics.newImage('assets/sprites/cpc_assets6.png'),
  love.graphics.newImage('assets/sprites/cpc_assets7.png'),
  love.graphics.newImage('assets/sprites/cpc_assets8.png'),
  love.graphics.newImage('assets/sprites/cpc_assets9.png'),
  love.graphics.newImage('assets/sprites/cpc_assets10.png'),
  love.graphics.newImage('assets/sprites/cpc_assets11.png'),
  love.graphics.newImage('assets/sprites/cpc_assets12.png'),
  love.graphics.newImage('assets/sprites/cpc_assets13.png'),
  love.graphics.newImage('assets/sprites/cpc_assets14.png'),
  love.graphics.newImage('assets/sprites/cpc_assets15.png'),
}
local idleFrames = utils.slice(characters, 2)
ivan.animations.idle = utils.initAnimation(idleFrames, 2, 0, 0, 21, 31, nil, 28)
ackboo.animations.idle = utils.initAnimation(idleFrames, 2, 20, 2, 17, 29, nil, 28)
izual.animations.idle = utils.initAnimation(idleFrames, 2, 37, 2, 17, 29, nil, 28)
sebum.animations.idle = utils.initAnimation(idleFrames, 2, 53, 2, 18, 29, nil, 28)
ellen.animations.idle = utils.initAnimation(idleFrames, 2, 72, 2, 15, 29, nil, 28)
local blinkFrames = utils.slice(characters, 1, 2)
ivan.animations.blink = utils.initAnimation(blinkFrames, 2, 0, 0, 21, 31, nil, 28)
ackboo.animations.blink = utils.initAnimation(blinkFrames, 2, 20, 2, 17, 29, nil, 28)
izual.animations.blink = utils.initAnimation(blinkFrames, 2, 37, 2, 17, 29, nil, 28)
sebum.animations.blink = utils.initAnimation(blinkFrames, 2, 53, 2, 18, 29, nil, 28)
ellen.animations.blink = utils.initAnimation(blinkFrames, 2, 72, 2, 15, 29, nil, 28)
local walkingFrames = utils.slice(characters, 10, 11)
ivan.animations.walking = utils.initAnimation(walkingFrames, 2, 0, 0, 21, 31, nil, 28)
ackboo.animations.walking = utils.initAnimation(walkingFrames, 2, 20, 2, 17, 29, nil, 28)
izual.animations.walking = utils.initAnimation(walkingFrames, 2, 37, 2, 17, 29, nil, 28)
sebum.animations.walking = utils.initAnimation(walkingFrames, 2, 53, 2, 18, 29, nil, 28)
ellen.animations.walking = utils.initAnimation(walkingFrames, 2, 72, 2, 15, 29, nil, 28)

local W, H = love.graphics.getDimensions()
local OX, OY = W / 2, H / 2

utils.ratio = 4 -- ternary(W / H < w / h, W / w, H / h)
utils.cw = 16
utils.ch = 4

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
  AIMING_WINDOW = 6, -- temps laissé au joueur pour viser
  PX1 = 0, PY1 = 24, -- départ des avions
  FLYING_SPEED = 50, -- vitesse des avions
  cell, -- case survolée
  aiming, -- bool
  aimingSpeed, -- vitesse de déplacement du viseur
  t0, t, -- date de début de la visé et date actuelle
  x, y, -- position du viseur
  updateCell = function(self, x, y)
    self.cell = utils.cellAt(x, y)
    self.aimingSpeed = 2 + .05 * self.cell.x
  end,
  update = function(self, dt)
    if self.aiming then
      self.t = self.t + self.aimingSpeed * dt
      local u, offset = self.t % 2, 0
      if u > 1 then
        offset = -10 * (2 - u)
      else
        offset = -10 * u
      end
      self.y = self.cell.y + offset
      if self.t > self.t0 + 6 then
        self:throw()
      end
    end
  end,
  aim = function(self)
    self.aiming = true
    self.x, self.y = self.cell.x, self.cell.y
    self.t = 2 * math.random()
    self.t0 = self.t
  end,
  throw = function(self)
    local p = {
      x1 = self.PX1,
      y1 = self.PY1,
      update = function(self, dt)
        self.t = math.min(self.t + self.speed * dt / self.len, 1)
        self.x = self.x1 + self.t * (self.x2 - self.x1)
        self.y = self.y1 + self.t * (self.y2 - self.y1)
        if self.t == 1 then
          self.update = nil
        end
      end
    }
    p.speed = self.FLYING_SPEED
    p.x2 = self.x + self.cell.y - utils.targetHeight(self.cell) - utils.round(self.y)
    p.y2 = self.cell.y
    p.len = math.sqrt((p.x2 - p.x1)^2 + (p.y2 - p.y1)^2)
    p.x, p.y = p.x1, p.y1
    p.t = 0
    p.quad = ({plane, test, mag, pile})[math.random(1, 4)]
    p.h = 1
    local cell = utils.cellAt(utils.worldCoordinates(p.x2, p.y2))
    table.insert(cell.objs, p)
    self.aiming = false
  end
}

function love.update(dt)
  gameState:update(dt)
  for x, row in pairs(utils.cells) do
    for y, cell in pairs(row) do
      local h = 0
      for k, obj in ipairs(cell.objs) do
        if obj.update then
          obj:update(dt)
        end
      end
    end
  end
  utils.updateAgent(ivan, dt)
  utils.updateAgent(ackboo, dt)
  utils.updateAgent(izual, dt)
  utils.updateAgent(sebum, dt)
  utils.updateAgent(ellen, dt)
end

love.graphics.setLineStyle('rough')
love.graphics.setLineWidth(utils.ratio)

function love.draw()
  love.graphics.setColor(1, 1, 1)
  utils.drawImage(background, OX, OY)
  if gameState.cell then
    utils.drawImage(cursor, utils.worldCoordinates(gameState.cell.x, gameState.cell.y))
    utils.drawQuad(ruler, utils.worldCoordinates(gameState.cell.x, gameState.cell.y))
    for i = -9, 0 do
      if i <= gameState.cell.x - 17 then -- à ajuster
        love.graphics.setColor(233 / 255, 54 / 255, 54 / 255)
      else
        love.graphics.setColor(251 / 255, 242 / 255, 54 / 255)
      end
      utils.drawQuad(tick, utils.worldCoordinates(gameState.cell.x, gameState.cell.y + i))
    end
    love.graphics.setColor(1, 1, 1)
    utils.drawQuad(goal, utils.worldCoordinates(gameState.cell.x, gameState.cell.y - utils.targetHeight(gameState.cell)))
    if gameState.aiming then
      utils.drawQuad(target, utils.worldCoordinates(gameState.x, gameState.y))
    end
  end
  for x, row in pairs(utils.cells) do
    for y, cell in pairs(row) do
      for k, obj in ipairs(cell.objs) do
        utils.drawQuad(obj.quad, utils.worldCoordinates(obj.x, obj.y))
      end
    end
  end
  utils.drawAgent(ivan)
  utils.drawAgent(ackboo)
  utils.drawAgent(izual)
  utils.drawAgent(sebum)
  utils.drawAgent(ellen)
  -- utils.drawText(texts.ackboo.test[1], utils.worldCoordinates(PATH.at(P)))
  -- utils.drawText(texts.izual.test[1], utils.worldCoordinates(5, 40))
  -- utils.drawText(texts.sebum.test[1], sx, sy)
  -- utils.drawText(texts.ellen.test[1], utils.worldCoordinates(15, 40))
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

-- function love.resize(w, h)
--   W, H = w, h
--   OX, OY = W / 2, H / 2
-- end