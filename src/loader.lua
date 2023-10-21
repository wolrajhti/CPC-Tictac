local Image = require 'src.graphics.image'
local Quad = require 'src.graphics.quad'
local Animation = require 'src.graphics.animation'

local function loader(utils)
  local data = {}

  data.background = Image.new('assets/sprites/background.png')

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
  data.waves = Animation.new(wavesFrames, .01)

  local logosFrames = {
    love.graphics.newImage('assets/sprites/logos/logos1.png'),
    love.graphics.newImage('assets/sprites/logos/logos2.png'),
    love.graphics.newImage('assets/sprites/logos/logos3.png'),
    love.graphics.newImage('assets/sprites/logos/logos4.png'),
    love.graphics.newImage('assets/sprites/logos/logos5.png'),
    love.graphics.newImage('assets/sprites/logos/logos6.png')
  }
  data.logos = Animation.new(logosFrames, .2)

  data.foreground = Image.new('assets/sprites/foreground.png')

  data.door = Image.new('assets/sprites/door.png')

  local textures = {
    love.graphics.newImage('assets/sprites/sprites1.png'),
    love.graphics.newImage('assets/sprites/sprites2.png'),
    love.graphics.newImage('assets/sprites/sprites3.png'),
    love.graphics.newImage('assets/sprites/sprites4.png')
  }
  data.dollarStart = Quad.new(textures[1], 52, 34, 3, 13)
  data.dollarStack = {
    Quad.new(textures[1], 55, 34, 3, 13),
    Quad.new(textures[1], 58, 34, 3, 13),
    Quad.new(textures[1], 61, 34, 3, 13),
    Quad.new(textures[1], 64, 34, 3, 13),
    Quad.new(textures[1], 67, 34, 3, 13),
    Quad.new(textures[1], 70, 34, 3, 13),
    Quad.new(textures[1], 73, 34, 3, 13),
    Quad.new(textures[1], 76, 34, 3, 13),
  }
  data.dollarEnd = Quad.new(textures[1], 79, 34, 8, 13, .5)
  data.cursor = Quad.new(textures[1], 66, 16, 22, 14)
  data.ruler = Quad.new(textures[1], 1, 1, 6, 46, nil, 43)
  data.tick = Quad.new(textures[1], 20, 5, 6, 6)
  data.goal = Quad.new(textures[1], 8, 12, 8, 8)
  data.target = Quad.new(textures[2], 15, 19, 20, 10)
  data.plane = Quad.new(textures[1], 19, 38, 11, 7, nil, 5)
  data.placeholder = Quad.new(textures[1], 71, 8, 12, 6)
  data.stress = {
    Quad.new(textures[1], 48, 0, 12, 5, nil, 33),
    Quad.new(textures[1], 48, 4, 12, 5, nil, 33),
    Quad.new(textures[1], 48, 8, 12, 5, nil, 33),
    Quad.new(textures[1], 48, 12, 12, 5, nil, 33),
    Quad.new(textures[1], 48, 16, 12, 5, nil, 33),
    Quad.new(textures[1], 48, 20, 12, 5, nil, 33),
    Quad.new(textures[1], 48, 24, 12, 5, nil, 33),
    Quad.new(textures[1], 48, 28, 12, 5, nil, 33)
  }

  local bookTexture = love.graphics.newImage('assets/sprites/books.png')
  data.article = Quad.new(bookTexture, 0, 64, 11, 7)
  -- data.article = Quad.new(bookTexture, 1, 80, 11, 7)
  -- TODO il faut quand meme écarter les piles pour les pb de clipping
  data.mags = {
    Quad.new(bookTexture, 11, 61, 11, 10, nil, 7),
    Quad.new(bookTexture, 22, 57, 11, 14, nil, 11),
    Quad.new(bookTexture, 33, 53, 11, 18, nil, 15),
    Quad.new(bookTexture, 44, 49, 11, 22, nil, 19),
    Quad.new(bookTexture, 55, 45, 11, 26, nil, 23),
    Quad.new(bookTexture, 66, 41, 11, 30, nil, 27),
    Quad.new(bookTexture, 77, 37, 11, 34, nil, 31),
    Quad.new(bookTexture, 88, 33, 11, 38, nil, 35),
    Quad.new(bookTexture, 99, 29, 11, 42, nil, 39),
    Quad.new(bookTexture, 110, 25, 11, 46, nil, 43) -- 10
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
      idle = {bodies[2]},
      walking = utils.slice(bodies, 12, 13),
      aiming = {bodies[15]}
    },
    head = {
      idle = {heads[2]},
      blink = utils.slice(heads, 1, 2),
      cry = {heads[4]},
      surprise = utils.slice(heads, 5, 6),
      laugh = utils.slice(heads, 7, 8),
      speak = utils.slice(heads, 16, 17)
    },
    item = {
      idle = utils.slice(items, 9, 10)
    }
  }

  local function helper(speed, x, y, w, h, ox, oy)
    local a = {
      body = {
        idle = Animation.new(frames.body.idle, speed, x, y, w, h, ox, oy),
        walking = Animation.new(frames.body.walking, speed, x, y, w, h, ox, oy),
        aiming = Animation.new(frames.body.aiming, speed, x, y, w, h, ox, oy)
      },
      head = {
        idle = Animation.new(frames.head.idle, speed, x, y, w, h, ox, oy),
        blink = Animation.new(frames.head.blink, speed, x, y, w, h, ox, oy, true),
        cry = Animation.new(frames.head.cry, speed, x, y, w, h, ox, oy),
        surprise = Animation.new(frames.head.surprise, speed, x, y, w, h, ox, oy, true),
        laugh = Animation.new(frames.head.laugh, speed * 3, x, y, w, h, ox, oy),
        speak = Animation.new(frames.head.speak, speed * 1.5, x, y, w, h, ox, oy),
      },
      item = {
        idle = Animation.new(frames.item.idle, speed, x, y, w, h, ox, oy)
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

  data.exploding = Animation.new(textures, 3, 15, 32, 18, 15, 9, 11, true)

  return data
end

return loader