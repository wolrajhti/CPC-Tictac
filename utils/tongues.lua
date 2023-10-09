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
      }
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
      }
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
      }
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
      }
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
      }
    }
  }
end


return loadTongues