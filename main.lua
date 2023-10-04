love.graphics.setDefaultFilter('nearest', 'nearest')

-- sprites
local utils = require 'utils'

local background = utils.initImage('assets/sprites/full_scene_2.png')
local cursor = utils.initImage('assets/sprites/cursor.png')
local textures = {
  love.graphics.newImage('assets/sprites/aim_system1.png'),
  love.graphics.newImage('assets/sprites/aim_system2.png'),
  love.graphics.newImage('assets/sprites/aim_system3.png'),
  love.graphics.newImage('assets/sprites/aim_system4.png'),
  love.graphics.newImage('assets/sprites/aim_system5.png'),
}
local ruler = utils.initQuad(textures[1], 1, 1, 6, 46, nil, 43)
local tick = utils.initQuad(textures[1], 10, 2, 4, 8, nil, 6)
local goal = utils.initQuad(textures[1], 8, 12, 8, 8)
local target = utils.initQuad(textures[1], 17, 17, 14, 14)
local plane = utils.initQuad(textures[1], 20, 39, 9, 5)
local stress = {
  utils.initQuad(textures[1], 48, 0, 12, 5, nil, 33),
  utils.initQuad(textures[1], 48, 4, 12, 5, nil, 33),
  utils.initQuad(textures[1], 48, 8, 12, 5, nil, 33),
  utils.initQuad(textures[1], 48, 12, 12, 5, nil, 33),
  utils.initQuad(textures[1], 48, 16, 12, 5, nil, 33),
  utils.initQuad(textures[1], 48, 20, 12, 5, nil, 33),
  utils.initQuad(textures[1], 48, 24, 12, 5, nil, 33)
}
local bookTexture = love.graphics.newImage('assets/sprites/books_2.png')
local test = utils.initQuad(bookTexture, 0, 64, 11, 7)
local mags = {
  utils.initQuad(bookTexture, 10, 61, 11, 10, nil, 7),
  utils.initQuad(bookTexture, 20, 57, 11, 14, nil, 11),
  utils.initQuad(bookTexture, 30, 53, 11, 18, nil, 15),
  utils.initQuad(bookTexture, 40, 49, 11, 22, nil, 19),
  utils.initQuad(bookTexture, 50, 45, 11, 26, nil, 23),
  utils.initQuad(bookTexture, 60, 41, 11, 30, nil, 27),
  utils.initQuad(bookTexture, 70, 37, 11, 34, nil, 31),
  utils.initQuad(bookTexture, 80, 33, 11, 38, nil, 35),
  utils.initQuad(bookTexture, 90, 29, 11, 42, nil, 39),
  utils.initQuad(bookTexture, 100, 25, 11, 46, nil, 43)
}

local ivan = {
  x = 2,
  y = 11,
  state = 'idle',
  reverse = love.math.random() < .5,
  t = 0,
  path = nil,
  animations = {},
  stress = 0
}

local ackboo = {
  x = 6,
  y = 40,
  state = 'idle',
  reverse = love.math.random() < .5,
  t = 0,
  path = nil,
  animations = {},
  stress = love.math.random(0, 7)
}

local izual = {
  x = 9,
  y = 40,
  state = 'idle',
  reverse = love.math.random() < .5,
  t = 0,
  path = nil,
  animations = {},
  stress = love.math.random(0, 7)
}

local sebum = {
  x = 12,
  y = 40,
  state = 'idle',
  reverse = love.math.random() < .5,
  t = 0,
  path = nil,
  animations = {},
  stress = love.math.random(0, 7)
}

local ellen = {
  x = 15,
  y = 40,
  state = 'idle',
  reverse = love.math.random() < .5,
  t = 0,
  path = nil,
  animations = {},
  stress = love.math.random(0, 7)
}

ivan.to = utils.cellAt(utils.worldCoordinates(ivan.x, ivan.y))
ackboo.to = utils.cellAt(utils.worldCoordinates(ackboo.x, ackboo.y))
izual.to = utils.cellAt(utils.worldCoordinates(izual.x, izual.y))
sebum.to = utils.cellAt(utils.worldCoordinates(sebum.x, sebum.y))
ellen.to = utils.cellAt(utils.worldCoordinates(ellen.x, ellen.y))
ivan.to.agent = ivan
ackboo.to.agent = ackboo
izual.to.agent = izual
sebum.to.agent = sebum
ellen.to.agent = ellen

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
  stress = stress, -- c'est n'importe quoi utils, gameState, les globals, ...
  updateCell = function(self, x, y)
    self.cell = utils.cellAt(x, y)
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
      self.weekend = self.day == 6 or self.day == 7 or
                     self.day == 13 or  self.day == 14 or
                     self.day == 20 or self.day == 21 or
                     self.day == 27 or self.day == 28
      if self.weekend then
        ackboo.stress = math.max(0, ackboo.stress - 1)
        izual.stress = math.max(0, izual.stress - 1)
        sebum.stress = math.max(0, sebum.stress - 1)
        ellen.stress = math.max(0, ellen.stress - 1)
      end
    end
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
    self.aimingSpeed = 2 + .05 * self.cell.x
    self.t = 2 * love.math.random()
    self.t0 = self.t
  end,
  throw = function(self)
    local p = {
      x1 = self.PX1,
      y1 = self.PY1,
      speed = self.FLYING_SPEED,
      x2 = self.x + self.cell.y - utils.targetHeight(self.cell) - utils.round(self.y),
      y2 = self.cell.y
    }
    p.len = math.sqrt((p.x2 - p.x1)^2 + (p.y2 - p.y1)^2)
    p.x, p.y = p.x1, p.y1
    p.t = 0
    p.quad = plane
    p.h = 1
    p.update = utils.updatePlane
    p.rand = love.math.random() - .25
    local cell = utils.cellAt(utils.worldCoordinates(p.x2, p.y2))
    if cell.walkable then
      table.insert(cell.flying, p)
    else
      table.insert(cell.missed, p)
    end
    self.aiming = false
  end
}

function love.update(dt)
  gameState:update(dt)
  utils.updateCells(dt)
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
  utils.drawCalendar(gameState)
  -- utils.drawWalkingAreas()
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
  utils.drawCells(gameState)
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