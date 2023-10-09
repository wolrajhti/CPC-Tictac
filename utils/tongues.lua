local function updateTongue(self, dt) -- body state
  self.t = self.t + dt
  if self.t > 3 then
    self.current = nil
  end
end

local function work(self)
  if not self.current then
    self.current = self.texts.work[love.math.random(1, #self.texts.work)]
    self.t = 0
  end
end

local function leaving(self)
  self.current = self.texts.leaving[love.math.random(1, #self.texts.leaving)]
  self.t = 0
end

local function random(self)
  if not self.current then
    self.current = self.texts.random[love.math.random(1, #self.texts.random)]
    self.t = 0
  end
end

local loadTongues = function(fonts)
  return {
    ivan = {
      font = fonts.ivan,
      color = {r = 251 / 255, g = 242 / 255, b = 54 / 255, a = 1}, -- JAUNE OR OU VERT BILLET
      background = {r = 251 / 255, g = 242 / 255, b = 54 / 255, a = 1}, -- JAUNE OU VERT
      current = nil,
      t = 0,
      texts = {
        work = {
          "WORK 1",
          "WORK 2",
          "WORK 3"
        },
        leaving = {
          "LEAVING 1",
          "LEAVING 2",
          "LEAVING 3"
        },
        random = {
          "RAND 1",
          "RAND 2",
          "RAND 3",
        }
      },
      update = updateTongue,
      work = work,
      leaving = leaving,
      random = random
    },
    ackboo = {
      font = fonts.ackboo,
      color = {r = 196, g = 0, b = 170, a = 1},
      background = {r = 1, g = 1, b = 1, a = 1},
      current = nil,
      t = 0,
      texts = {
        work = {
          "WORK 1",
          "WORK 2",
          "WORK 3"
        },
        leaving = {
          "LEAVING 1",
          "LEAVING 2",
          "LEAVING 3"
        },
        random = {
          "RAND 1",
          "RAND 2",
          "RAND 3",
        }
      },
      update = updateTongue,
      work = work,
      leaving = leaving,
      random = random
    },
    izual = {
      font = fonts.izual,
      color = {r = 0, g = 0, b = 0, a = 1}, -- JAUNE OR OU VERT BILLET
      background = {r = 1, g = 1, b = 1, a = 1}, -- JAUNE OU VERT
      current = nil,
      t = 0,
      texts = {
        work = {
          "WORK 1",
          "WORK 2",
          "WORK 3"
        },
        leaving = {
          "LEAVING 1",
          "LEAVING 2",
          "LEAVING 3"
        },
        random = {
          "RAND 1",
          "RAND 2",
          "RAND 3",
        }
      },
      update = updateTongue,
      work = work,
      leaving = leaving,
      random = random
    },
    sebum = {
      font = fonts.sebum,
      color = {r = 1, g = 1, b = 1, a = 1}, -- JAUNE OR OU VERT BILLET
      background = {r = 170 / 255, g = 108 / 255, b = 45 / 255, a = 1}, -- JAUNE OU VERT
      current = nil,
      t = 0,
      texts = {
        work = {
          "WORK 1",
          "WORK 2",
          "WORK 3"
        },
        leaving = {
          "LEAVING 1",
          "LEAVING 2",
          "LEAVING 3"
        },
        random = {
          "RAND 1",
          "RAND 2",
          "RAND 3",
        }
      },
      update = updateTongue,
      work = work,
      leaving = leaving,
      random = random
    },
    ellen = {
      font = fonts.ellen,
      color = {r = 1, g = 1, b = 1, a = 1}, -- JAUNE OR OU VERT BILLET
      background = {r = .1, g = .1, b = .1, a = 1}, -- JAUNE OU VERT
      current = nil,
      t = 0,
      texts = {
        work = {
          "WORK 1",
          "WORK 2",
          "WORK 3"
        },
        leaving = {
          "LEAVING 1",
          "LEAVING 2",
          "LEAVING 3"
        },
        random = {
          "RAND 1",
          "RAND 2",
          "RAND 3",
        }
      },
      update = updateTongue,
      work = work,
      leaving = leaving,
      random = random
    }
  }
end


return loadTongues