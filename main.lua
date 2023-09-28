love.graphics.setDefaultFilter('nearest', 'nearest')

local aim_system = love.graphics.newImage('assets/sprites/aim_system.png')
local asw, ash = aim_system:getDimensions()
local ruler = love.graphics.newQuad(1, 1, 6, 46, asw, ash)
local tick = love.graphics.newQuad(10, 2, 4, 8, asw, ash)
local goal = love.graphics.newQuad(8, 12, 8, 8, asw, ash)
local target = love.graphics.newQuad(17, 17, 14, 14, asw, ash)
local plane = love.graphics.newQuad(20, 39, 9, 5, asw, ash)
local background = love.graphics.newImage('assets/sprites/full_scene_2.png')
local cursor = love.graphics.newImage('assets/sprites/cursor.png')
local cuw, cuh = cursor:getDimensions()
local w, h = background:getDimensions()
local W, H = love.graphics.getDimensions()
local OX, OY = W / 2, H / 2

local function ternary(cond, T, F)
  if cond then return T else return F end
end

local ratio = ternary(W / H < w / h, W / w, H / h)

local function cell_at(x, y)
  return {
    x = math.floor(x / (16 * ratio)) * (16 * ratio) + (-2 * ratio), -- le -2 final est l'offset de la grille
    y = math.floor(y / (4 * ratio)) * (4 * ratio) + (-2 * ratio),
    h = 0
  }
end

local current_cell
local aiming = false
local t0

local flying = false
local PSPEED = 1000
local px0, py0 = 0, 7 * H / 12
local px1, py1
local px, py
local plen, pt

local function throw()
  aiming = false
  flying = true
  py1 = py1 - 34 * ratio -- sacrément dégueux
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
      offset = 10 * (2 - u)
    else
      offset = 10 * u
    end
    py1 = current_cell.y + (10 - offset) * ratio * 4
    if t > t0 + 6 then
      throw()
    end
  elseif flying then
    pt = math.min(pt + PSPEED * dt / plen, 1)
    px = px0 + pt * (px1 - px0)
    py = py0 + pt * (py1 - py0)
  end
end

love.graphics.setLineStyle('rough')
love.graphics.setLineWidth(ratio)

function love.draw()
  love.graphics.setColor(1, 1, 1)
  love.graphics.draw(background, OX, OY, 0, ratio, ratio, w / 2, h / 2)
  if current_cell then
    love.graphics.draw(cursor, current_cell.x, current_cell.y, 0, ratio, ratio, -2, -2)
    love.graphics.draw(aim_system, ruler, current_cell.x, current_cell.y, 0, ratio, ratio, -9, 37)
    for i = 1, 10 do
      if i < current_cell.x / (32 * ratio) then
        love.graphics.setColor(233 / 255, 54 / 255, 54 / 255)
      else
        love.graphics.setColor(251 / 255, 242 / 255, 54 / 255)
      end
      love.graphics.draw(aim_system, tick, current_cell.x, current_cell.y + (i - 1) * ratio * 4, 0, ratio, ratio, -10, 36)
    end
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(aim_system, goal, current_cell.x, current_cell.y + (10 - current_cell.h) * ratio * 4, 0, ratio, ratio, -8, 38)
    if aiming then
      love.graphics.draw(aim_system, target, current_cell.x, py1, 0, ratio, ratio, -5, 41)
    end
  end
  if flying then
    love.graphics.setColor(0, 0, 0)
    love.graphics.line(px0, py0, px1, py1)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(aim_system, plane, px, py, 0, ratio, ratio)
  end
end

function love.mousemoved(x, y)
  if not aiming then
    current_cell = cell_at(x, y)
    SPEED = 2 + .05 * math.floor(current_cell.x / (16 * ratio))
  end
end

function love.mousepressed(x, y, button)
  if button == 1 then
    aiming = true
    px1, py1 = current_cell.x + (16 * ratio) / 2 + 13, current_cell.y
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