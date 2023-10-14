local Image = {}
Image.mt = {__index = Image}

function Image.new(filename, ox, oy)
  local image = love.graphics.newImage(filename)
  local w, h = image:getDimensions()
  local new = {
    image = image,
    w = w, -- à supprimer si useless
    h = h, -- à supprimer si useless
    ox = ox or w / 2,
    oy = oy or h / 2
  }
  setmetatable(new, Image.mt)
  return new
end

function Image.draw(self, scale, x, y)
  love.graphics.draw(self.image, x, y, 0, scale, scale, self.ox, self.oy)
end

return Image