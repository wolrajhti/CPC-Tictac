local loadTextUtils = function(utils)
  utils.text = {}

  function utils.text.init(font, str, ox, oy)
    text = love.graphics.newText(font, str)
    local w, h = text:getDimensions()
    return {
      len = #str,
      text = text,
      w = w,
      h = h,
      ox = ox or w / 2,
      oy = oy or h / 2
    }
  end
  
  function utils.text.drawSpeak(tongue, x, y)
    utils.getColor()
    love.graphics.setColor(tongue.background.r, tongue.background.g, tongue.background.b, tongue.background.a)
    love.graphics.rectangle('fill',
      x - (tongue.current.w / 8 + 1) * utils.ratio,
      y - (tongue.current.h / 4 + 3) * utils.ratio - 29 * utils.ratio - (utils.ratio / 2), -- dernier arg pour l'alignement
      (tongue.current.w / 4 + 2) * utils.ratio,
      (tongue.current.h / 4 + 2) * utils.ratio
    )
    love.graphics.setColor(tongue.color.r, tongue.color.g, tongue.color.b, tongue.color.a)
    love.graphics.draw(tongue.current.text, x, y - 29 * utils.ratio, 0, utils.ratio / 4, utils.ratio / 4, tongue.current.w / 2, tongue.current.h + 3 * utils.ratio)
    utils.setColor(r, g, b, a)
  end

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
