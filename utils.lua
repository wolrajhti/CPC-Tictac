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

function utils.initPath(vertices)
  local lens = {}
  local len = 0
  for i = 1, #vertices - 1 do
    len = len + math.sqrt((vertices[i + 1][1] - vertices[i][1])^2 + (vertices[i + 1][2] - vertices[i][2])^2)
    table.insert(lens, len)
  end
  return {
    at = function(l)
      local prev = 0
      for i, len in ipairs(lens) do
        if l <= len then
          local coef = (l - prev) / (len - prev)
          return vertices[i][1] + coef * (vertices[i + 1][1] - vertices[i][1]),
            vertices[i][2] + coef * (vertices[i + 1][2] - vertices[i][2])
        end
        prev = len
      end
      return vertices[#vertices][1], vertices[#vertices][2]
    end
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