local loadTextUtils = function(utils)
  utils.text = {}

  function utils.text.init(font, str, ox, oy)
    text = love.graphics.newText(font, str)
    local w, h = text:getDimensions()
    return {
      text = text,
      w = w,
      h = h,
      ox = ox or w / 2,
      oy = oy or h / 2
    }
  end
  
  -- function utils.text.draw(data, x, y)
  --   utils.getColor()
  --   love.graphics.setColor(0, 0, 0, 0.3)
  --   love.graphics.rectangle('fill',
  --     x - (data.w / 2 + utils.ratio),
  --     y - (data.h + 3 * utils.ratio) - 29 * utils.ratio,
  --     data.w + 2 * utils.ratio,
  --     data.h + 2 * utils.ratio
  --   )
  --   -- love.graphics.setColor(0, 0, 0)
  --   -- love.graphics.rectangle('line', x - (tw / 2 + utils.ratio), y - (th + 3 * utils.ratio) - 29 * utils.ratio, tw + 2 * utils.ratio, th + 2 * utils.ratio)
  --   love.graphics.setColor(1, 1, 1)
  --   -- voir si plus performant si on utilise utils.ratio, utils.ratio à la place de 1, 1
  --   love.graphics.draw(text, x, y - 29 * utils.ratio, 0, 1, 1, data.w / 2, data.h + 3 * utils.ratio)
  --   love.graphics.circle('fill', x, y, 4)
  --   utils.setColor(r, g, b, a)
  -- end

  function utils.text.draw(data, x, y)
    love.graphics.draw(data.text, x, y, 0, utils.ratio / 2, utils.ratio / 2, data.ox, data.oy)
  end

  function utils.text.drawSmall(data, x, y)
    love.graphics.draw(data.text, x, y, 0, utils.ratio / 4, utils.ratio / 4, data.ox, data.oy)
  end
  
  function utils.text.drawTitle(data, x, y)
    love.graphics.draw(data.text, x, y, 0, utils.ratio, utils.ratio, data.ox, data.oy)
  end
  
  -- function utils.text.drawSubtitle(data, x, y)
  -- end
end

return loadTextUtils
