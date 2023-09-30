local utils = {
  ratio = 1,
  cw = 16,
  ch = 4,
  cells = {}
}

function utils.cellAt(x, y)
  x, y = utils.cellCoordinates(x, y)
  if not utils.cells[x] then
    utils.cells[x] = {[y] = {x = x, y = y, objs = {}}} -- h pour tester
  elseif not utils.cells[x][y] then
    utils.cells[x][y] = {x = x, y = y, objs = {}} -- h pour tester
  end
  return utils.cells[x][y]
end

function utils.targetHeight(cell)
  local h = 0
  for i, v in ipairs(cell.objs) do
    h = h + v.h
  end
  return h
end

function utils.worldCoordinates(x, y)
  return (x + .5) * utils.cw * utils.ratio, (y + .5) * utils.ch * utils.ratio
end

function utils.cellCoordinates(x, y)
  return math.floor(x / (utils.cw * utils.ratio)), math.floor(y / (utils.ch * utils.ratio))
end

function utils.initImage(filename)
  local image = love.graphics.newImage(filename)
  local w, h = image:getDimensions()
  return {
    image = image,
    w = w, -- à supprimer si useless
    h = h, -- à supprimer si useless
    ox = w / 2,
    oy = h / 2
  }
end

function utils.initQuad(texture, x, y, width, height, ox, oy)
  return {
    texture = texture,
    quad = love.graphics.newQuad(x, y, width, height, texture:getDimensions()),
    ox = ox or width / 2,
    oy = oy or height / 2
  }
end

function utils.initAnimation(frames, speed, x, y, width, height, ox, oy)
  local t = 0
  return {
    update = function (self, dt)
      t = (t + speed * dt) % 1
      self.texture = frames[math.floor(#frames * t) + 1]
    end,
    texture = frames[1],
    quad = love.graphics.newQuad(x, y, width, height, frames[1]:getDimensions()),
    ox = ox or width / 2,
    oy = oy or height / 2
  }
end

function utils.initText(font, str)
  text = love.graphics.newText(font, str)
  local w, h = text:getDimensions()
  return {
    text = text,
    w = w,
    h = h
  }
end

function utils.initPath(x1, y1, x2, y2)
  local len = math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
  local t = 0
  return {
    update = function(t, dt)
      return math.min(t + (.001 / len) * dt, 1)
    end,
    at = function(t)
      return x1 + t * (x2 - x1), y1 + t * (y2 - y1)
    end
  }
end

function utils.drawImage(data, x, y)
  love.graphics.draw(data.image, x, y, 0, utils.ratio, utils.ratio, data.ox, data.oy)
end

function utils.drawQuad(data, x, y)
  love.graphics.draw(data.texture, data.quad, x, y, 0, utils.ratio, utils.ratio, data.ox, data.oy)
end

local r, g, b, a
function utils.drawText(data, x, y)
  r, g, b, a = love.graphics.getColor()
  love.graphics.setColor(0, 0, 0, 0.3)
  love.graphics.rectangle('fill',
    x - (data.w / 2 + utils.ratio),
    y - (data.h + 3 * utils.ratio) - 29 * utils.ratio,
    data.w + 2 * utils.ratio,
    data.h + 2 * utils.ratio
  )
  -- love.graphics.setColor(0, 0, 0)
  -- love.graphics.rectangle('line', x - (tw / 2 + utils.ratio), y - (th + 3 * utils.ratio) - 29 * utils.ratio, tw + 2 * utils.ratio, th + 2 * utils.ratio)
  love.graphics.setColor(1, 1, 1)
  -- voir si plus performant si on utilise utils.ratio, utils.ratio à la place de 1, 1
  love.graphics.draw(text, x, y - 29 * utils.ratio, 0, 1, 1, data.w / 2, data.h + 3 * utils.ratio)
  love.graphics.circle('fill', x, y, 4)
  love.graphics.setColor(r, g, b, a)
end

function utils.ternary(cond, T, F)
  if cond then return T else return F end
end

function utils.round(x)
  return math.floor(x + .5)
end

return utils