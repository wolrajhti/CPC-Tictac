local utils = {
  ratio = 1,
  cw = 16,
  ch = 4,
  cells = {}
}

function utils.cellAt(x, y)
  x, y = utils.cellCoordinates(x, y)
  if not utils.cells[x] then
    utils.cells[x] = {[y] = {x = x, y = y, objs = {{h = math.random(5, 5)}}}} -- h pour tester
  elseif not utils.cells[x][y] then
    utils.cells[x][y] = {x = x, y = y, objs = {{h = math.random(5, 5)}}} -- h pour tester
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

function utils.drawImage(data, x, y)
  love.graphics.draw(data.image, x, y, 0, utils.ratio, utils.ratio, data.ox, data.oy)
end

function utils.drawQuad(data, x, y)
  love.graphics.draw(data.texture, data.quad, x, y, 0, utils.ratio, utils.ratio, data.ox, data.oy)
end

function utils.ternary(cond, T, F)
  if cond then return T else return F end
end

function utils.round(x)
  return math.floor(x + .5)
end

return utils