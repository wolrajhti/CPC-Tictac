local utils = require 'src.utils'
local Image = require 'src.graphics.image'
local Quad = require 'src.graphics.quad'
local Animation = require 'src.graphics.animation'
local Text = require 'src.text'
local Tongue = require 'src.tongues' -- TODO rename

local loader = {}

function loader.load()
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
      idle = utils.slice(bodies, 2),
      walking = utils.slice(bodies, 12, 13),
      aiming = utils.slice(bodies, 15)
    },
    head = {
      idle = utils.slice(heads, 2),
      blink = utils.slice(heads, 1, 2),
      cry = utils.slice(heads, 4),
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

  -- fonts
  data.fonts = {
    default = love.graphics.newImageFont('assets/fonts/Resource-Imagefont.png',
      " abcdefghijklmnopqrstuvwxyz" ..
      "ABCDEFGHIJKLMNOPQRSTUVWXYZ0" ..
      "123456789.,!?-+/():;%&`'*#=[]\""
    ),
    ackboo = love.graphics.newFont('assets/fonts/comic-sans-ms/ComicSansMS3.ttf'),
    izual = love.graphics.newFont('assets/fonts/upheaval/upheavtt.ttf', 20),
    sebum = love.graphics.newFont('assets/fonts/alagard.ttf', 24)
  }
  data.fonts.ivan = data.fonts.default
  data.fonts.ellen = data.fonts.default

  data.colors = {
    ivan = {
      color = {r = 251 / 255, g = 242 / 255, b = 54 / 255, a = 1},
      background = {r = 251 / 255, g = 242 / 255, b = 54 / 255, a = 1}
    },
    ackboo = {
      color = {r = 196, g = 0, b = 170, a = 1},
      background = {r = 1, g = 1, b = 1, a = 1},
    },
    izual = {
      color = {r = 0, g = 0, b = 0, a = 1},
      background = {r = 1, g = 1, b = 1, a = 1},
    },
    sebum = {
      color = {r = 1, g = 1, b = 1, a = 1},
      background = {r = 170 / 255, g = 108 / 255, b = 45 / 255, a = 1},
    },
    ellen = {
      color = {r = 1, g = 1, b = 1, a = 1},
      background = {r = .1, g = .1, b = .1, a = 1},
    }
  }

  data.quotes = {
    default = {
      start = Text.new(data.fonts.default, "C'est partiiii !"),
      pause = Text.new(data.fonts.default, ""),
      money = Text.new(data.fonts.default, ""),
      article = Text.new(data.fonts.default, ""),
      mag = Text.new(data.fonts.default, ""),
      gameOver = Text.new(data.fonts.default, "GAME OVER"),
      home = Text.new(data.fonts.default, "a Tactical Air Pigiste game for the \"Make Something Horrible, l'edition des 20 ans\" by Wolrajhti")
    },
    ivan = {
      work = {},
      leaving = {},
      random = {
        Text.new(data.fonts.ivan, "bip.. Hello Bobby ! ... Yes we will give\nyou the ten, don't worry"),
        Text.new(data.fonts.ivan, "bip.. Yves ? Comment vas-tu ? Chez barney's demain\nmidi comme d'habitude ?"),
        Text.new(data.fonts.ivan, "bip.. Mouais encore des fruits mers ? t'es sur ?"),
        Text.new(data.fonts.ivan, "Allez, m'obligez pas a retourner chialer\nsur Kickstarter"),
        Text.new(data.fonts.ivan, "Ca part en impression demain, grouillez-vous !"),
        Text.new(data.fonts.ivan, "Je suis pas convaincu par la democratie en entreprise"),
        Text.new(data.fonts.ivan, "C'est l'heure des bonbons !"),
        Text.new(data.fonts.ivan, "Mais p****n, abonnez-vouuuuus nom de dieu !")
      },
      aim = {
        Text.new(data.fonts.ivan, "On dit demain 9h ?"),
        Text.new(data.fonts.ivan, "Ya pas d'argent magique"),
        Text.new(data.fonts.ivan, "Ca fait plus de mal a moi qu'a toi"),
        Text.new(data.fonts.ivan, "On le met en couv ?"),
        Text.new(data.fonts.ivan, "Et haut les coeurs"),
        Text.new(data.fonts.ivan, "J'attend ton retour ASAP"),
        Text.new(data.fonts.ivan, "Chaud devant !"),
        Text.new(data.fonts.ivan, "J'arrivais pas a te joindre, t'es en\nweekend un samedi ?!")
      }
    },
    ackboo = {
      work = {
        Text.new(data.fonts.ackboo, "Pas compatible vSync .. 6/10"),
        Text.new(data.fonts.ackboo, "Bien, mais il pleut. J'aime pas la pluie\n5/10"),
        Text.new(data.fonts.ackboo, "On peut pas decorer sa maison 7/10"),
        Text.new(data.fonts.ackboo, "On peut pas remapper en azerty .. a chier 3/10"),
        Text.new(data.fonts.ackboo, "Parce que j'aime la vie et les toyos 10/10"),
        Text.new(data.fonts.ackboo, "Ce jeu est ce que sont les raquettes à picots au ping-pong :\nUNE ES-CROQUE-RIE 0/10")
      },
      leaving = {
        Text.new(data.fonts.ackboo, "Jsuis pas jojo le clodo !"),
        Text.new(data.fonts.ackboo, "Au moins il me reste Corentin"),
        Text.new(data.fonts.ackboo, "Ya l'audio book Napoleon Tome XVII qui\nm'attend les amis"),
        Text.new(data.fonts.ackboo, "Allez on va mettre la viande dans le torchon ..."),
        Text.new(data.fonts.ackboo, "Ca fait zizir")
      },
      random = {
        Text.new(data.fonts.ackboo, "Laissez passer, jsuis journaliste\ncarte de presse, tout ca, tout ca"),
        Text.new(data.fonts.ackboo, "Alors Izual, On tient les murs ?"),
        Text.new(data.fonts.ackboo, "Sebum ? t'en penses quoi ?"),
        Text.new(data.fonts.ackboo, "Jme lsuis mis partout"),
        Text.new(data.fonts.ackboo, "Papy il a faim"),
        Text.new(data.fonts.ackboo, "Vous devriez essayer, on a l'air con, mais qu'est-ce\nque c'est BIEN !!"),
        Text.new(data.fonts.ackboo, "Est-ce que je vous ai deja parler de mon crush de seconde ?"),
        Text.new(data.fonts.ackboo, "Vous voulez voir mon gros joystick ?"),
        Text.new(data.fonts.ackboo, "Ca jpeux pas vous le raconter... NAN il faut savoir\ngarder un jardin secret."),
        Text.new(data.fonts.ackboo, "C'est quoi cette multi prise en plein milieu de la piece ?")
      },
      aim = {}
    },
    izual = {
      work = {
        Text.new(data.fonts.izual, "Ce que le capitalisme sait faire de\nmieux 9/10"),
        Text.new(data.fonts.izual, "A l'unanimite le congres attribut la\nnote supreme de 8/10"),
        Text.new(data.fonts.izual, "Le ministere du videoludisme ne censure\npas... a tord parfois"),
        Text.new(data.fonts.izual, "Camarade, si tu as une config a plus\nde 3k euros, ce jeu est fait pour\ntoi 7/10"),
        Text.new(data.fonts.izual, "Et puis quoi encore, de l'IA dans nos cereales\nle matin ?! 0/10"),
        Text.new(data.fonts.izual, "C'est a l'isometrique, mais c'est pas\nFallout 2 ... 3/10"),
        Text.new(data.fonts.izual, "Si vous avez une ame, desinstallez le"),
        Text.new(data.fonts.izual, "Le militant dit NON, mais faut avouer qu'on\nse marre bien"),
      },
      leaving = {
        Text.new(data.fonts.izual, "Nous ne nous laisserons pas faire !"),
        Text.new(data.fonts.izual, "bip.. Oui bonjour, c'est bien les\nprud'hommes ?"),
        Text.new(data.fonts.izual, "C'est toujours les memes qui a profite le systeme"),
        Text.new(data.fonts.izual, "Ca vous derange d'avoir quelqu'un qui assume\nses positions... c'est ca ?!"),
        Text.new(data.fonts.izual, "L'ascenseur social est casse")
      },
      random = {
        Text.new(data.fonts.izual, "Piouuu piouu piouuu..."),
        Text.new(data.fonts.izual, "tagadadadadadada.."),
        Text.new(data.fonts.izual, "Mmmm ouais jsuis vege, et toi ?"),
        Text.new(data.fonts.izual, "mmmmmMMMMMMMMMMNNNNNN...\npppBRUIIIIITCH. PINNN..\nPONN..PINNN..."),
        Text.new(data.fonts.izual, "He... Dis camion"),
        Text.new(data.fonts.izual, "G sui tesTeur 2 JEu Video."),
        Text.new(data.fonts.izual, "La guerre c'est mal. On s'fait\nun ARMA les copains ?"),
        Text.new(data.fonts.izual, "Accrochez vos ceintures, on est parti pour\nun stream de 7h"),
        Text.new(data.fonts.izual, "Ta G***LE Ackboo !"),
        Text.new(data.fonts.izual, "Arrete Ackboo, tu sais que t'as tord"),
        Text.new(data.fonts.izual, "On a dit pas de politique"),
        Text.new(data.fonts.izual, "Chat, la video 3.. le fichier que\nje t'avais mis sur la cle..\nDEVANT TOI P****N !")
      },
      aim = {}
    },
    sebum = {
      work = {
        Text.new(data.fonts.sebum, "Une experience tres synesthesique :\nPost-modernisme / 10"),
        Text.new(data.fonts.sebum, "Le trublion du Boomer-Shooter : Casu / 10"),
        Text.new(data.fonts.sebum, "Votre body-awareness va en prenre un coup !"),
        Text.new(data.fonts.sebum, "Uncanny as f**ck 8/10"),
        Text.new(data.fonts.sebum, "Reouvre le debAt des pro taxonomie Vs\npro arbre de competence. Tres\ninteressant 9/10"),
        Text.new(data.fonts.sebum, "Ce qu'est le quaternion a la 3D : IM-BI-TABLE 3/10"),
        Text.new(data.fonts.sebum, "Nutri-score tres bAs 6/10"),
        Text.new(data.fonts.sebum, "Pour les gros nerds quadrA 7/10"),
        Text.new(data.fonts.sebum, "Je les avais rencontre a une jam inde sur le\ntheme des acides phosphoriques : tres cool")
      },
      leaving = {
        Text.new(data.fonts.sebum, "Qu'il en soit ainsi..."),
        Text.new(data.fonts.sebum, "Tchao les amis !"),
        Text.new(data.fonts.sebum, "C'est au moins l'occasion de finir d'apprendre\nle code source de DOOM\npar coeur"),
      },
      random = {
        Text.new(data.fonts.sebum, "Mais attend on dit de-gin-gande ou de-GUIN-gande ?\nAh ! euh dans ... \"En avant gingamp\" ... ?!\nAh oui mais : GIN-gembre ? ..."),
        Text.new(data.fonts.sebum, "C'est .... AAAssez interessant ..."),
        Text.new(data.fonts.sebum, "Jsuis turbo sexy"),
        Text.new(data.fonts.sebum, "AHAH CA ! c'est typiquement Ackboo"),
        Text.new(data.fonts.sebum, "Hmm moui .. un peu ... avec plus de cheveux j'imagine"),
        Text.new(data.fonts.sebum, "Mais teeeeeeeeeeellllement"),
      },
      aim = {}
    },
    ellen = {
      work = {
        Text.new(data.fonts.ellen, "Si vous avez une PS5 et 20H devant vous\nfoncez 8/10"),
        Text.new(data.fonts.ellen, "Moi j'ai trouve ca pas mal 6/10"),
        Text.new(data.fonts.ellen, "Des zombies qui mangent des ratons-laveurs,\nfranchement peut-on rever mieux ?\n10/10"),
        Text.new(data.fonts.ellen, "A les moyens de ses ambitions 9/10"),
        Text.new(data.fonts.ellen, "Va-t-il transformer l'essai ? ?/10"),
        Text.new(data.fonts.ellen, "Tres Ibura Sataki dans l'esprit ... 7/10"),
        Text.new(data.fonts.ellen, "Tout le mondre reconnaitra dans la DA une\npate tres Iroshi Himosoto 8/10"),
        Text.new(data.fonts.ellen, "Le crunch peut donner de bons resultats\n8/10"),
        Text.new(data.fonts.ellen, "Le 1er jeu pour homme tronc.. helas tres chiant\nil faut dire, desole.. 2/10"),
        Text.new(data.fonts.ellen, "Hyper interessant et permet d'apprehender\nl'approche systemique tellement 90s\nde Nakato TAKAMITO"),
        Text.new(data.fonts.ellen, "Sympas ces amateurs de rencontres \"IRL\",\nj'espere que l'article vous plaira"),
        Text.new(data.fonts.ellen, "Detrompez vous la figure du chien a beaucoup evolue\ndans la vision occidentale des shooters COOP.")
      },
      leaving = {
        Text.new(data.fonts.ellen, "Peut etre a une prochaine fois, n'hesitez pas\nles temps sont dur hein ..."),
        Text.new(data.fonts.ellen, "J'ai beaucoup appris, c'etait une tres bonne experience"),
        Text.new(data.fonts.ellen, "Pas de probleme, je comprends, bah oui, la crise\ntout ca tout ca"),
        Text.new(data.fonts.ellen, "Vous etes de belles personnes ... sauf toi Ackboo"),
      },
      random = {
        Text.new(data.fonts.ellen, "...Henry Mac Guire dans STOMP IV bien sur. evidemment ..."),
        Text.new(data.fonts.ellen, "Ah oui comme John Brossvitch ! Ses jeunes\nannees on est d'accord"),
        Text.new(data.fonts.ellen, "Calmez vous les enfants"),
        Text.new(data.fonts.ellen, "(Ellen tu es la redactrice en chef, il faut que\ntu lui expliques qu'il ne peut copier sur le\ntest de son voisin)"),
        Text.new(data.fonts.ellen, "Ackboo on avait dit pas les mamans !"),
        Text.new(data.fonts.ellen, "Ackboo lache ca !"),
        Text.new(data.fonts.ellen, "Ackboo range ce truc"),
        Text.new(data.fonts.ellen, "Le patron quel chic type tout de meme"),
        Text.new(data.fonts.ellen, "Hmmm ouais. ouais.")
      },
      aim = {}
    }
  }

  data.ivanSpeaks = Tongue.new(data.colors.ivan.color, data.colors.ivan.background, data.quotes.ivan)
  data.ackbooSpeaks = Tongue.new(data.colors.ackboo.color, data.colors.ackboo.background, data.quotes.ackboo)
  data.izualSpeaks = Tongue.new(data.colors.izual.color, data.colors.izual.background, data.quotes.izual)
  data.sebumSpeaks = Tongue.new(data.colors.sebum.color, data.colors.sebum.background, data.quotes.sebum)
  data.ellenSpeaks = Tongue.new(data.colors.ellen.color, data.colors.ellen.background, data.quotes.ellen)

  return data
end

return loader