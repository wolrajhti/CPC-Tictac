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
    local xMin = x - (tongue.current.w / 8 + 1) * utils.ratio
    local yMin = y - (tongue.current.h / 4 + 3) * utils.ratio - 29 * utils.ratio - (utils.ratio / 2)
    local w = (tongue.current.w / 4 + 2) * utils.ratio
    local h = (tongue.current.h / 4 + 2) * utils.ratio
    local xOffset, yOffset = 0, 0
    if xMin < 4 * utils.ratio then
      xOffset = 4 * utils.ratio - xMin
    elseif (utils.bw - 4) * utils.ratio < xMin + w then
      xOffset = (utils.bw - 4) * utils.ratio - (xMin + w)
    end
    if yMin < 4 * utils.ratio then
      yOffset = 4 * utils.ratio - yMin
    elseif (utils.bh - 4) * utils.ratio < yMin + h then
      yOffset = (utils.bh - 4) * utils.ratio - (yMin + h)
    end
    love.graphics.rectangle('fill',
      xMin + xOffset, yMin + yOffset,
      w, h
    )
    love.graphics.setColor(tongue.color.r, tongue.color.g, tongue.color.b, tongue.color.a)
    love.graphics.draw(
      tongue.current.text,
      x + xOffset, y - 29 * utils.ratio - 3 * utils.ratio + yOffset,
      0,
      utils.ratio / 4, utils.ratio / 4,
      tongue.current.w / 2, tongue.current.h
    )
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
