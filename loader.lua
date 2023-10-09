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

  local cloudsFrames = {
    love.graphics.newImage('assets/sprites/clouds/clouds1.png'),
    love.graphics.newImage('assets/sprites/clouds/clouds2.png'),
    love.graphics.newImage('assets/sprites/clouds/clouds3.png'),
    love.graphics.newImage('assets/sprites/clouds/clouds4.png'),
    love.graphics.newImage('assets/sprites/clouds/clouds5.png'),
    love.graphics.newImage('assets/sprites/clouds/clouds6.png')
  }
  table.insert(cloudsFrames, cloudsFrames[5])
  table.insert(cloudsFrames, cloudsFrames[4])
  table.insert(cloudsFrames, cloudsFrames[3])
  table.insert(cloudsFrames, cloudsFrames[2])
  data.clouds = utils.initAnimation(cloudsFrames, .02)

  local logosFrames = {
    love.graphics.newImage('assets/sprites/logos/logos1.png'),
    love.graphics.newImage('assets/sprites/logos/logos2.png'),
    love.graphics.newImage('assets/sprites/logos/logos3.png'),
    love.graphics.newImage('assets/sprites/logos/logos4.png'),
    love.graphics.newImage('assets/sprites/logos/logos5.png'),
    love.graphics.newImage('assets/sprites/logos/logos6.png')
  }
  data.logos = utils.initAnimation(logosFrames, .1)

  data.foreground = utils.initImage('assets/sprites/foreground.png')

  data.door = utils.initImage('assets/sprites/door.png')

  local textures = {
    love.graphics.newImage('assets/sprites/aim_system1.png'),
    love.graphics.newImage('assets/sprites/aim_system2.png'),
    love.graphics.newImage('assets/sprites/aim_system3.png'),
    love.graphics.newImage('assets/sprites/aim_system4.png')
  }
  data.dollarStart = utils.initQuad(textures[1], 49, 34, 3, 13)
  data.dollarStack = {
    utils.initQuad(textures[1], 52, 34, 3, 13),
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

  local bookTexture = love.graphics.newImage('assets/sprites/books_2.png')
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

  local characters = {
    love.graphics.newImage('assets/sprites/cpc_assets1.png'),
    love.graphics.newImage('assets/sprites/cpc_assets2.png'),
    love.graphics.newImage('assets/sprites/cpc_assets3.png'),
    love.graphics.newImage('assets/sprites/cpc_assets4.png'),
    love.graphics.newImage('assets/sprites/cpc_assets5.png'),
    love.graphics.newImage('assets/sprites/cpc_assets6.png'),
    love.graphics.newImage('assets/sprites/cpc_assets7.png'),
    love.graphics.newImage('assets/sprites/cpc_assets8.png'),
    love.graphics.newImage('assets/sprites/cpc_assets9.png'),
    love.graphics.newImage('assets/sprites/cpc_assets10.png'),
    love.graphics.newImage('assets/sprites/cpc_assets11.png'),
    love.graphics.newImage('assets/sprites/cpc_assets12.png'),
    love.graphics.newImage('assets/sprites/cpc_assets13.png'),
    love.graphics.newImage('assets/sprites/cpc_assets14.png'),
    love.graphics.newImage('assets/sprites/cpc_assets15.png'),
  }

  local idleFrames = utils.slice(characters, 2)
  local blinkFrames = utils.slice(characters, 1, 2)
  local walkingFrames = utils.slice(characters, 10, 11)
  local aimingFrames = utils.slice(characters, 13)

  local ivanWalking = utils.initAnimation(walkingFrames, 2, 0, 0, 21, 31, nil, 28)
  data.ivanAnimations = {
    idle = utils.initAnimation(idleFrames, 2, 0, 0, 21, 31, nil, 28),
    blink = utils.initAnimation(blinkFrames, 2, 0, 0, 21, 31, nil, 28),
    walking = ivanWalking,
    leaving = ivanWalking,
    goingToWork = ivanWalking,
    work = ivanWalking,
    aiming = utils.initAnimation(aimingFrames, 2, 0, 0, 21, 31, nil, 28)
  }

  local ackbooWalking = utils.initAnimation(walkingFrames, 2, 20, 2, 17, 29, nil, 28)
  data.ackbooAnimations = {
    idle = utils.initAnimation(idleFrames, 2, 20, 2, 17, 29, nil, 28),
    blink = utils.initAnimation(blinkFrames, 2, 20, 2, 17, 29, nil, 28),
    walking = ackbooWalking,
    leaving = ackbooWalking,
    goingToWork = ackbooWalking,
    work = ackbooWalking
  }

  local izualWalking = utils.initAnimation(walkingFrames, 2, 37, 2, 17, 29, nil, 28)
  data.izualAnimations = {
    idle = utils.initAnimation(idleFrames, 2, 37, 2, 17, 29, nil, 28),
    blink = utils.initAnimation(blinkFrames, 2, 37, 2, 17, 29, nil, 28),
    walking = izualWalking,
    leaving = izualWalking,
    goingToWork = izualWalking,
    work = izualWalking
  }

  local sebumWalking = utils.initAnimation(walkingFrames, 2, 53, 2, 18, 29, nil, 28)
  data.sebumAnimations = {
    idle = utils.initAnimation(idleFrames, 2, 53, 2, 18, 29, nil, 28),
    blink = utils.initAnimation(blinkFrames, 2, 53, 2, 18, 29, nil, 28),
    walking = sebumWalking,
    leaving = sebumWalking,
    goingToWork = sebumWalking,
    work = sebumWalking
  }

  local ellenWalking = utils.initAnimation(walkingFrames, 2, 72, 2, 15, 29, nil, 28)
  data.ellenAnimations = {
    idle = utils.initAnimation(idleFrames, 2, 72, 2, 15, 29, nil, 28),
    blink = utils.initAnimation(blinkFrames, 2, 72, 2, 15, 29, nil, 28),
    walking = ellenWalking,
    leaving = ellenWalking,
    goingToWork = ellenWalking,
    work = ellenWalking
  }

  data.exploding = utils.initAnimation(textures, 3, 15, 32, 18, 15, 9, 11, true)

  return data
end

return loader