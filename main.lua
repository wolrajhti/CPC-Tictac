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

local W, H = love.graphics.getDimensions()
local OX, OY = W / 2, H / 2

utils.ratio = 4 -- ternary(W / H < w / h, W / w, H / h)
utils.cw = 16
utils.ch = 4

local cell
local aiming = false
local t0

local flying = false
local PSPEED = 50
local px0, py0 = 0, 24
local px1, py1
local px, py
local plen, pt

local function throw()
  py1 = utils.round(py1)
  px1 = px1 + cell.y - utils.targetHeight(cell) - utils.round(py1)
  py1 = cell.y
  aiming = false
  flying = true
  plen = math.sqrt((px1 - px0)^2 + (py1 - py0)^2)
  px = px0
  py = py0
  pt = 0
end

local t = 0
local SPEED = 1

function love.update(dt)
  if aiming then
    t = t + SPEED * dt
    local u, offset = t % 2, 0
    if u > 1 then
      offset = -10 * (2 - u)
    else
      offset = -10 * u
    end
    py1 = cell.y + offset
    if t > t0 + 6 then
      throw()
    end
  elseif flying then
    pt = math.min(pt + PSPEED * dt / plen, 1)
    px = px0 + pt * (px1 - px0)
    py = py0 + pt * (py1 - py0)
    if pt == 1 then
      flying = false
      local cell = utils.cellAt(utils.worldCoordinates(px, py))
      table.insert(cell.objs, {quad = plane, h = 1})
    end
  end
end

love.graphics.setLineStyle('rough')
love.graphics.setLineWidth(utils.ratio)

function love.draw()
  love.graphics.setColor(1, 1, 1)
  utils.drawImage(background, OX, OY)
  if cell then
    utils.drawImage(cursor, utils.worldCoordinates(cell.x, cell.y))
    utils.drawQuad(ruler, utils.worldCoordinates(cell.x, cell.y))
    for i = -9, 0 do
      if i <= cell.x - 17 then -- à ajuster
        love.graphics.setColor(233 / 255, 54 / 255, 54 / 255)
      else
        love.graphics.setColor(251 / 255, 242 / 255, 54 / 255)
      end
      utils.drawQuad(tick, utils.worldCoordinates(cell.x, cell.y + i))
    end
    love.graphics.setColor(1, 1, 1)
    utils.drawQuad(goal, utils.worldCoordinates(cell.x, cell.y - utils.targetHeight(cell)))
    if aiming then
      utils.drawQuad(target, utils.worldCoordinates(cell.x, py1))
    end
  end
  if flying then
    -- love.graphics.setColor(0, 0, 0)
    -- local a, b = utils.worldCoordinates(px0, py0)
    -- love.graphics.line(a, b, utils.worldCoordinates(px1, py1))
    -- love.graphics.setColor(1, 1, 1)
    utils.drawQuad(plane, utils.worldCoordinates(px, py))
  end
  for x, row in pairs(utils.cells) do
    for y, cell in pairs(row) do
      local h = 0
      for k, obj in ipairs(cell.objs) do
        utils.drawQuad(obj.quad, utils.worldCoordinates(x, y - h))
        h = h + obj.h
      end
    end
  end
end

function love.mousemoved(x, y)
  if not aiming then
    cell = utils.cellAt(x, y)
    SPEED = 2 + .05 * cell.x
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    aiming = true
    px1, py1 = cell.x, cell.y
    t = 2 * math.random()
    t0 = t
  end
end

function love.mousereleased(x, y, button)
  if button == 1 and aiming then
    throw()
  end
end

-- function love.resize(w, h)
--   W, H = w, h
--   OX, OY = W / 2, H / 2
-- end