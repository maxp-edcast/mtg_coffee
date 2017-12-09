{
  Input,
  CostConstructor,
  CardConstructor,
  PlayerConstructor,
  GameConstructor
} = require "./game.coffee"

sample_cost = {
  CostConstructor()...,
  colorless: 1
}

sample_card = {
  CardConstructor()...,
  cost: sample_cost
}

sample_player_1 = {
  PlayerConstructor()...,
  name: "player 1"
}

sample_player_2 = {
  PlayerConstructor()...,
  name: "player 2"
}

game = {
  GameConstructor()...,
  players: [sample_player_1, sample_player_2]
}

game.start()