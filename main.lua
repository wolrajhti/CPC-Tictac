love.graphics.setDefaultFilter('nearest', 'nearest')

local aim_system = love.graphics.newImage('assets/sprites/aim_system.png')
local asw, ash = aim_system:getDimensions()
local ruler = love.graphics.newQuad(1, 1, 6, 46, asw, ash)
local tick = love.graphics.newQuad(10, 2, 4, 8, asw, ash)
local goal = love.graphics.newQuad(8, 12, 8, 8, asw, ash)
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
    h = 10
  }
end

local current_cell

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
  end
end

function love.mousemoved(x, y)
  current_cell = cell_at(x, y)
end

-- function love.resize(w, h)
--   W, H = w, h
--   OX, OY = W / 2, H / 2
-- end