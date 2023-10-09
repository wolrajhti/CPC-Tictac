local function loader(utils)
  local data = {}

  data.background = utils.initImage('assets/sprites/background.png')

  local wavesFrames = {
    love.graphics.newImage('assets/sprites/waves/waves1.png'),
    love.graphics.newImage('assets/sprites/waves/waves2.png'),
    love.graphics.newImage('assets/sprites/waves/waves3.png'),
    love.graphics.newImage('assets/sprites/waves/waves4.png'),
    love.graphics.newImage('assets/sprites/waves/waves5.png'),
    love.graphics.newImage('assets/sprites/waves/waves6.png')
  }
  table.insert(wavesFrames, wavesFrames[5])
  table.insert(wavesFrames, wavesFrames[4])
  table.insert(wavesFrames, wavesFrames[3])
  table.insert(wavesFrames, wavesFrames[2])
  data.waves = utils.initAnimation(wavesFrames, .01)

  local logosFrames = {
    love.graphics.newImage('assets/sprites/logos/logos1.png'),
    love.graphics.newImage('assets/sprites/logos/logos2.png'),
    love.graphics.newImage('assets/sprites/logos/logos3.png'),
    love.graphics.newImage('assets/sprites/logos/logos4.png'),
    love.graphics.newImage('assets/sprites/logos/logos5.png'),
    love.graphics.newImage('assets/sprites/logos/logos6.png')
  }
  data.logos = utils.initAnimation(logosFrames, .2)

  data.foreground = utils.initImage('assets/sprites/foreground.png')

  data.door = utils.initImage('assets/sprites/door.png')

  local textures = {
    love.graphics.newImage('assets/sprites/sprites1.png'),
    love.graphics.newImage('assets/sprites/sprites2.png'),
    love.graphics.newImage('assets/sprites/sprites3.png'),
    love.graphics.newImage('assets/sprites/sprites4.png')
  }
  data.dollarStart = utils.initQuad(textures[1], 52, 34, 3, 13)
  data.dollarStack = {
    utils.initQuad(textures[1], 55, 34, 3, 13),
    utils.initQuad(textures[1], 58, 34, 3, 13),
    utils.initQuad(textures[1], 61, 34, 3, 13),
    utils.initQuad(textures[1], 64, 34, 3, 13),
    utils.initQuad(textures[1], 67, 34, 3, 13),
    utils.initQuad(textures[1], 70, 34, 3, 13),
    utils.initQuad(textures[1], 73, 34, 3, 13),
    utils.initQuad(textures[1], 76, 34, 3, 13),
  }
  data.dollarEnd = utils.initQuad(textures[1], 79, 34, 8, 13, .5)
  data.cursor = utils.initQuad(textures[1], 66, 16, 22, 14)
  data.ruler = utils.initQuad(textures[1], 1, 1, 6, 46, nil, 43)
  data.tick = utils.initQuad(textures[1], 20, 5, 6, 6)
  data.goal = utils.initQuad(textures[1], 8, 12, 8, 8)
  data.target = utils.initQuad(textures[2], 15, 19, 20, 10)
  data.plane = utils.initQuad(textures[1], 19, 38, 11, 7, nil, 5)
  data.placeholder = utils.initQuad(textures[1], 71, 8, 12, 6)
  data.stress = {
    utils.initQuad(textures[1], 48, 0, 12, 5, nil, 33),
    utils.initQuad(textures[1], 48, 4, 12, 5, nil, 33),
    utils.initQuad(textures[1], 48, 8, 12, 5, nil, 33),
    utils.initQuad(textures[1], 48, 12, 12, 5, nil, 33),
    utils.initQuad(textures[1], 48, 16, 12, 5, nil, 33),
    utils.initQuad(textures[1], 48, 20, 12, 5, nil, 33),
    utils.initQuad(textures[1], 48, 24, 12, 5, nil, 33),
    utils.initQuad(textures[1], 48, 28, 12, 5, nil, 33)
  }

  local bookTexture = love.graphics.newImage('assets/sprites/books.png')
  data.article = utils.initQuad(bookTexture, 0, 64, 11, 7)
  -- data.article = utils.initQuad(bookTexture, 1, 80, 11, 7)
  -- TODO il faut quand meme écarter les piles pour les pb de clipping
  data.mags = {
    utils.initQuad(bookTexture, 11, 61, 11, 10, nil, 7),
    utils.initQuad(bookTexture, 22, 57, 11, 14, nil, 11),
    utils.initQuad(bookTexture, 33, 53, 11, 18, nil, 15),
    utils.initQuad(bookTexture, 44, 49, 11, 22, nil, 19),
    utils.initQuad(bookTexture, 55, 45, 11, 26, nil, 23),
    utils.initQuad(bookTexture, 66, 41, 11, 30, nil, 27),
    utils.initQuad(bookTexture, 77, 37, 11, 34, nil, 31),
    utils.initQuad(bookTexture, 88, 33, 11, 38, nil, 35),
    utils.initQuad(bookTexture, 99, 29, 11, 42, nil, 39),
    utils.initQuad(bookTexture, 110, 25, 11, 46, nil, 43) -- 10
    -- utils.initQuad(bookTexture, 12, 73, 11, 14, nil, 11),
    -- utils.initQuad(bookTexture, 23, 65, 11, 22, nil, 19),
    -- utils.initQuad(bookTexture, 34, 57, 11, 30, nil, 27),
    -- utils.initQuad(bookTexture, 45, 49, 11, 38, nil, 35),
    -- utils.initQuad(bookTexture, 56, 41, 11, 46, nil, 43),
    -- utils.initQuad(bookTexture, 67, 33, 11, 54, nil, 51),
    -- utils.initQuad(bookTexture, 78, 25, 11, 62, nil, 59),
    -- utils.initQuad(bookTexture, 89, 17, 11, 70, nil, 67),
    -- utils.initQuad(bookTexture, 100, 9, 11, 78, nil, 75),
    -- utils.initQuad(bookTexture, 111, 1, 11, 86, nil, 83) -- 10
  }

  local bodies = {
    love.graphics.newImage('assets/sprites/bodies/bodies1.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies2.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies3.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies4.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies5.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies6.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies7.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies8.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies9.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies10.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies11.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies12.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies13.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies14.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies15.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies16.png'),
    love.graphics.newImage('assets/sprites/bodies/bodies17.png'),
  }

  local heads = {
    love.graphics.newImage('assets/sprites/heads/heads1.png'),
    love.graphics.newImage('assets/sprites/heads/heads2.png'),
    love.graphics.newImage('assets/sprites/heads/heads3.png'),
    love.graphics.newImage('assets/sprites/heads/heads4.png'),
    love.graphics.newImage('assets/sprites/heads/heads5.png'),
    love.graphics.newImage('assets/sprites/heads/heads6.png'),
    love.graphics.newImage('assets/sprites/heads/heads7.png'),
    love.graphics.newImage('assets/sprites/heads/heads8.png'),
    love.graphics.newImage('assets/sprites/heads/heads9.png'),
    love.graphics.newImage('assets/sprites/heads/heads10.png'),
    love.graphics.newImage('assets/sprites/heads/heads11.png'),
    love.graphics.newImage('assets/sprites/heads/heads12.png'),
    love.graphics.newImage('assets/sprites/heads/heads13.png'),
    love.graphics.newImage('assets/sprites/heads/heads14.png'),
    love.graphics.newImage('assets/sprites/heads/heads15.png'),
    love.graphics.newImage('assets/sprites/heads/heads16.png'),
    love.graphics.newImage('assets/sprites/heads/heads17.png'),
  }

  local items = {
    love.graphics.newImage('assets/sprites/items/items1.png'),
    love.graphics.newImage('assets/sprites/items/items2.png'),
    love.graphics.newImage('assets/sprites/items/items3.png'),
    love.graphics.newImage('assets/sprites/items/items4.png'),
    love.graphics.newImage('assets/sprites/items/items5.png'),
    love.graphics.newImage('assets/sprites/items/items6.png'),
    love.graphics.newImage('assets/sprites/items/items7.png'),
    love.graphics.newImage('assets/sprites/items/items8.png'),
    love.graphics.newImage('assets/sprites/items/items9.png'),
    love.graphics.newImage('assets/sprites/items/items10.png'),
    love.graphics.newImage('assets/sprites/items/items11.png'),
    love.graphics.newImage('assets/sprites/items/items12.png'),
    love.graphics.newImage('assets/sprites/items/items13.png'),
    love.graphics.newImage('assets/sprites/items/items14.png'),
    love.graphics.newImage('assets/sprites/items/items15.png'),
    love.graphics.newImage('assets/sprites/items/items16.png'),
    love.graphics.newImage('assets/sprites/items/items17.png'),
  }

  local frames = {
    body = {
      idle = utils.slice(bodies, 2),
      walking = utils.slice(bodies, 12, 13),
      aiming = utils.slice(bodies, 15)
    },
    head = {
      idle = utils.slice(heads, 2),
      blink = utils.slice(heads, 1, 2),
      cry = utils.slice(heads, 4),
      surprise = utils.slice(heads, 5, 6)
    },
    item = {
      idle = utils.slice(items, 9, 10)
    }
  }

  local function helper(speed, x, y, w, h, ox, oy)
    local a = {
      body = {
        idle = utils.initAnimation(frames.body.idle, speed, x, y, w, h, ox, oy),
        walking = utils.initAnimation(frames.body.walking, speed, x, y, w, h, ox, oy),
        aiming = utils.initAnimation(frames.body.aiming, speed, x, y, w, h, ox, oy)
      },
      head = {
        idle = utils.initAnimation(frames.head.idle, speed, x, y, w, h, ox, oy),
        blink = utils.initAnimation(frames.head.blink, speed, x, y, w, h, ox, oy, true),
        cry = utils.initAnimation(frames.head.cry, speed, x, y, w, h, ox, oy),
        surprise = utils.initAnimation(frames.head.surprise, speed, x, y, w, h, ox, oy, true),
      },
      item = {
        idle = utils.initAnimation(frames.item.idle, speed, x, y, w, h, ox, oy)
      }
    }
    a.body.goingToWork = a.body.walking
    a.body.work = a.body.walking
    a.body.leaving = a.body.walking
    return a
  end

  data.ivanAnimations = helper(2, 0, 0, 21, 31, nil, 28)
  data.ackbooAnimations = helper(2, 20, 2, 17, 29, nil, 28)
  data.ackbooAnimations.item.idle.speed = 10 -- GROS HACK
  data.izualAnimations = helper(2, 37, 2, 17, 29, nil, 28)
  data.sebumAnimations = helper(2, 53, 2, 18, 29, nil, 28)
  data.ellenAnimations = helper(2, 72, 2, 15, 29, nil, 28)

  data.exploding = utils.initAnimation(textures, 3, 15, 32, 18, 15, 9, 11, true)

  return data
end

return loader