local COUNT = 0;
local MAX = 3;

local function updateTongue(self, dt) -- body state
  self.t = self.t + dt
  if self.t > 6 then
    self.current = nil
    if self.callback then
      self.callback() -- TODO horrible d'avoir a passer une fonction... il faudrait avoir accès à l'agent
    end
    COUNT = COUNT - 1
  end
end

local function work(self, callback)
  if COUNT < MAX and not self.current and #self.texts.work > 0 then
    self.current = self.texts.work[love.math.random(1, #self.texts.work)]
    self.t = 0
    self.callback = callback
    COUNT = COUNT + 1
  end
end

local function leaving(self, callback)
  if COUNT < MAX then
    self.current = self.texts.leaving[love.math.random(1, #self.texts.leaving)]
    self.t = 0
    self.callback = callback
    COUNT = COUNT + 1
  end
end

local function random(self, callback)
  if COUNT < MAX and not self.current and #self.texts.random > 0 then
    self.current = self.texts.random[love.math.random(1, #self.texts.random)]
    self.t = 0
    self.callback = callback
    COUNT = COUNT + 1
  end
end

local function aim(self, callback)
  if COUNT < MAX and not self.current and #self.texts.aim > 0 then
    self.current = self.texts.aim[love.math.random(1, #self.texts.aim)]
    self.t = 0
    self.callback = callback
    COUNT = COUNT + 1
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
        work = {},
        leaving = {},
        random = {
          "bip.. Hello Bobby ! ... Yes we will give\nyou the ten, don't worry",
          "bip.. Yves ? Comment vas-tu ? Chez barney's demain\nmidi comme d'habitude ?",
          "bip.. Mouais encore des fruits mers ? t'es sur ?",
          "Allez, m'obligez pas a retourner chialer\nsur Kickstarter",
          "Ca part en impression demain, grouillez-vous !",
          "Je suis pas convaincu par la democratie en entreprise",
          "C'est l'heure des bonbons !",
          "Mais p****n, abonnez-vouuuuus nom de dieu !"
        },
        aim = {
          "On dit demain 9h ?",
          "Ya pas d'argent magique",
          "Ca fait plus de mal a moi qu'a toi",
          "On le met en couv ?",
          "Et haut les coeurs",
          "J'attend ton retour ASAP",
          "Chaud devant !",
          "J'arrivais pas a te joindre, t'es en\nweekend un samedi ?!"
        }
      },
      update = updateTongue,
      work = work,
      leaving = leaving,
      random = random,
      aim = aim
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
          "On peut pas decorer sa maison 7/10",
          "On peut pas remapper en azerty .. a chier 3/10",
          "Parce que j'aime la vie et les toyos 10/10",
          "Ce jeu est ce que sont les raquettes à picots au ping-pong :\nUNE ES-CROQUE-RIE 0/10"
        },
        leaving = {
          "Jsuis pas jojo le clodo !",
          "Au moins il me reste Corentin",
          "Ya l'audio book Napoleon Tome XVII qui\nm'attend les amis",
          "Allez on va mettre la viande dans le torchon ...",
          "Ca fait zizir"
        },
        random = {
          "Laissez passer, jsuis journaliste\ncarte de presse, tout ca, tout ca",
          "Alors Izual, On tient les murs ?",
          "Sebum ? t'en penses quoi ?",
          "Jme lsuis mis partout",
          "Papy il a faim",
          "Vous devriez essayer, on a l'air con, mais qu'est-ce\nque c'est BIEN !!",
          "Est-ce que je vous ai deja parler de mon crush de seconde ?",
          "Vous voulez voir mon gros joystick ?",
          "Ca jpeux pas vous le raconter... NAN il faut savoir\ngarder un jardin secret.",
          "C'est quoi cette multi prise en plein milieu de la piece ?"
        },
        aim = {}
      },
      update = updateTongue,
      work = work,
      leaving = leaving,
      random = random,
      aim = aim
    },
    izual = {
      font = fonts.izual,
      color = {r = 0, g = 0, b = 0, a = 1}, -- JAUNE OR OU VERT BILLET
      background = {r = 1, g = 1, b = 1, a = 1}, -- JAUNE OU VERT
      current = nil,
      t = 0,
      texts = {
        work = {
          "Ce que le capitalisme sait faire de\nmieux 9/10",
          "A l'unanimite le congres attribut la\nnote supreme de 8/10",
          "Le ministere du videoludisme ne censure\npas... a tord parfois",
          "Camarade, si tu as une config a plus\nde 3k euros, ce jeu est fait pour\ntoi 7/10",
          "Et puis quoi encore, de l'IA dans nos cereales\nle matin ?! 0/10",
          "C'est a l'isometrique, mais c'est pas\nFallout 2 ... 3/10",
          "Si vous avez une ame, desinstallez le",
          "Le militant dit NON, mais faut avouer qu'on\nse marre bien",
        },
        leaving = {
          "Nous ne nous laisserons pas faire !",
          "bip.. Oui bonjour, c'est bien les\nprud'hommes ?",
          "C'est toujours les memes qui a profite le systeme",
          "Ca vous derange d'avoir quelqu'un qui assume\nses positions... c'est ca ?!",
          "L'ascenseur social est casse"
        },
        random = {
          "Piouuu piouu piouuu...",
          "tagadadadadadada..",
          "Mmmm ouais jsuis vege, et toi ?",
          "mmmmmMMMMMMMMMMNNNNNN...\npppBRUIIIIITCH. PINNN..\nPONN..PINNN...",
          "He... Dis camion",
          "G sui tesTeur 2 JEu Video.",
          "La guerre c'est mal. On s'fait\nun ARMA les copains ?",
          "Accrochez vos ceintures, on est parti pour\nun stream de 7h",
          "Ta G***LE Ackboo !",
          "Arrete Ackboo, tu sais que t'as tord",
          "On a dit pas de politique",
          "Chat, la video 3.. le fichier que\nje t'avais mis sur la cle..\nDEVANT TOI P****N !"
        },
        aim = {}
      },
      update = updateTongue,
      work = work,
      leaving = leaving,
      random = random,
      aim = aim
    },
    sebum = {
      font = fonts.sebum,
      color = {r = 1, g = 1, b = 1, a = 1}, -- JAUNE OR OU VERT BILLET
      background = {r = 170 / 255, g = 108 / 255, b = 45 / 255, a = 1}, -- JAUNE OU VERT
      current = nil,
      t = 0,
      texts = {
        work = {
          "Une experience tres synesthesique :\nPost-modernisme / 10",
          "Le trublion du Boomer-Shooter : Casu / 10",
          "Votre body-awareness va en prenre un coup !",
          "Uncanny as f**ck 8/10",
          "Reouvre le debAt des pro taxonomie Vs\npro arbre de competence. Tres\ninteressant 9/10",
          "Ce qu'est le quaternion a la 3D : IM-BI-TABLE 3/10",
          "Nutri-score tres bAs 6/10",
          "Pour les gros nerds quadrA 7/10",
          "Je les avais rencontre a une jam inde sur le\ntheme des acides phosphoriques : tres cool"
        },
        leaving = {
          "Qu'il en soit ainsi...",
          "Tchao les amis !",
          "C'est au moins l'occasion de finir d'apprendre\nle code source de DOOM\npar coeur",
        },
        random = {
          "Mais attend on dit de-gin-gande ou de-GUIN-gande ?\nAh ! euh dans ... \"En avant gingamp\" ... ?!\nAh oui mais : GIN-gembre ? ...",
          "C'est .... AAAssez interessant ...",
          "Jsuis turbo sexy",
          "AHAH CA ! c'est typiquement Ackboo",
          "Hmm moui .. un peu ... avec plus de cheveux j'imagine",
          "Mais teeeeeeeeeeellllement",
        },
        aim = {}
      },
      update = updateTongue,
      work = work,
      leaving = leaving,
      random = random,
      aim = aim
    },
    ellen = {
      font = fonts.ellen,
      color = {r = 1, g = 1, b = 1, a = 1}, -- JAUNE OR OU VERT BILLET
      background = {r = .1, g = .1, b = .1, a = 1}, -- JAUNE OU VERT
      current = nil,
      t = 0,
      texts = {
        work = {
          "Si vous avez une PS5 et 20H devant vous\nfoncez 8/10",
          "Moi j'ai trouve ca pas mal 6/10",
          "Des zombies qui mangent des ratons-laveurs,\nfranchement peut-on rever mieux ?\n10/10",
          "A les moyens de ses ambitions 9/10",
          "Va-t-il transformer l'essai ? ?/10",
          "Tres Ibura Sataki dans l'esprit ... 7/10",
          "Tout le mondre reconnaitra dans la DA une\npate tres Iroshi Himosoto 8/10",
          "Le crunch peut donner de bons resultats\n8/10",
          "Le 1er jeu pour homme tronc.. helas tres chiant\nil faut dire, desole.. 2/10",
          "Hyper interessant et permet d'apprehender\nl'approche systemique tellement 90s\nde Nakato TAKAMITO",
          "Sympas ces amateurs de rencontres \"IRL\",\nj'espere que l'article vous plaira",
          "Detrompez vous la figure du chien a beaucoup evolue\ndans la vision occidentale des shooters COOP."
        },
        leaving = {
          "Peut etre a une prochaine fois, n'hesitez pas\nles temps sont dur hein ...",
          "J'ai beaucoup appris, c'etait une tres bonne experience",
          "Pas de probleme, je comprends, bah oui, la crise\ntout ca tout ca",
          "Vous etes de belles personnes ... sauf toi Ackboo",
        },
        random = {
          "...Henry Mac Guire dans STOMP IV bien sur. evidemment ...",
          "Ah oui comme John Brossvitch ! Ses jeunes\nannees on est d'accord",
          "Calmez vous les enfants",
          "(Ellen tu es la redactrice en chef, il faut que\ntu lui expliques qu'il ne peut copier sur le\ntest de son voisin)",
          "Ackboo on avait dit pas les mamans !",
          "Ackboo lache ca !",
          "Ackboo range ce truc",
          "Le patron quel chic type tout de meme",
          "Hmmm ouais. ouais."
        },
        aim = {}
      },
      update = updateTongue,
      work = work,
      leaving = leaving,
      random = random,
      aim = aim
    }
  }
end

return loadTongues