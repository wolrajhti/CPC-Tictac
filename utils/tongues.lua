local function updateTongue(self, dt) -- body state
  self.t = self.t + dt
  if self.t > 3 then
    self.current = nil
  end
end

local function work(self)
  if not self.current and #self.texts.work > 0 then
    self.current = self.texts.work[love.math.random(1, #self.texts.work)]
    self.t = 0
  end
end

local function leaving(self)
  self.current = self.texts.leaving[love.math.random(1, #self.texts.leaving)]
  self.t = 0
end

local function random(self)
  if not self.current and #self.texts.random > 0 then
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
          "Oh nooon ya que 3 dinosaurus...",
          "Vous connaissez le papier toilette humide ?",
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
          "Pas compatible vSync .. 6/10",
          "Bien, mais il pleut. J'aime pas la pluie\n5/10",
          "On peut pas decorer sa maison, d'ailleurs\nya pas de maison dans le jeu 7/10",
          "On peut remapper en azerty .. a chier 3/10",
          "Parce que j'aime la vie 10/10",
          -- "Aussi desagréable que les raquettes de ping-pong à picots ! 2/10"
          "Ce jeu est ce que sont les raquettes à picots au ping-pong :\nUNE ES-CROQUE-RIE 0/10"
        },
        leaving = {
          "Jsuis pas jojo le clodo !",
          "Au moins il me reste Corentin",
          "Ya l'audio book Napoleon Tome XVII qui\nm'attend les amis"
        },
        random = {
          "Laissez passer, jsuis journaliste\ncarte de presse, tout ca, tout ca",
          "Ca fait zizir",
          "On tient les murs",
          "Papy il a faim"
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
          -- "Une experience tres synesthesique : Post-modernisme / 10",
          -- "Le trublion du Boomer-Shooter : Casu / 10",
          -- "Votre body-awareness va en prenre un coup !",
          -- "Uncanny as f**ck 8/10",
          "Reouvre le debat des pro taxonomie Vs pro arbre de\ncompetence. Tres interessant 9/10",
          "Ce qu'est le quaternion a la 3D : IM-BI-TABLE 3/10",
          "Nutri-score tres bas 6/10",
          "Pour les gros nerds quadr-A 7/10"
        },
        leaving = {
          "Qu'il en soit ainsi ... maitre",
        },
        random = {
          "Mais attend on dit de-gin-gande ou de-GUIN-gande ?\nAh ! euh dans ... \"En avant gingamp\" ... ?!\nAh oui mais : GIN-gembre ? ... je suis perplexe",
          "C'est .... A-ssez interessant ...",
          "Jsuis turbo sexy"
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