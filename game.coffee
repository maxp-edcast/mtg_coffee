module.exports = Namespace = {}

Namespace.Input = (->
  @get_choice = (player, prompt, opts...) =>
    throw "User input not implemented"
  this
).apply {}

Namespace.CostConstructor = -> (->
  @red = 0
  @green = 0
  @black = 0
  @blue = 0
  @colorless = 0
  @x = 0
  @total = (only) =>
    keys = ["red", "green", "black", "blue", "colorless"]
    only ||= keys
    keys.filter (key) ->
      only.includes(key)
    .reduce (count, key) ->
      count + this[key]
    , 0
  this
).apply {}

Namespace.CardConstructor = -> (->
  @is_counter = false
  @type = ""
  @subtype = ""
  @cost = Namespace.CostConstructor()
  this
).apply {}

Namespace.PlayerConstructor = -> (->
  @name = ''
  @deck = []
  @hand = []
  @graveyard = []
  @exile = []
  @life = 20
  @skips_draw = false
  @move_hand_to_graveyard = =>
  @mulligan = =>
      hand_size = @hand.length
      @move_hand_to_graveyard()
      @draw(hand_size - 1)
      top_card = @deck[0]
  @bottom_card_cost = =>
    @deck.reverse[0].total()
  @shuffle_deck = =>
    @deck = @deck.shuffle()
  @draw = (num_cards) =>
    @hand.push @deck.splice(0,num_cards)...
  @move_top_cards_to_bottom = (num) =>
    @library.push @library.splice(0, num)
  this
).apply {}

Namespace.GameConstructor = -> (->
  @players = []
  @turn_order = []
  @current_turn_idx = 0
  @running = false
  @current_player = =>
    @turn_order[@current_turn_idx]
  @go_to_next_player = =>
    @current_turn_idx = (@current_turn_idx + 1) % @turn_order.length
  @start = =>
    @running = true
    @current_turn_idx = @find_initial_turn_idx()
    @other_players = @players.filter (player) =>
      player.name != @whos_turn.name
    player.shuffle_deck() for player in @players
    @turn_order = [@whos_turn, @other_players...]
    @first_move_of_game()
  @first_move_of_game = =>
    player.draw(7) for player in @turn_order
    @do_mulligans()
    @ask_for_play_or_draw()
    @start_game_loop()
  @ask_for_mulligans = =>
    @turn_order.forEach (player) =>
      did_mulligan = false
      while player.hand.length > 0 && Input.get_choice(player, "mulligan?", true, false)
        @player.mulligan()
        did_mulligan = true
      if did_mulligan
        if Input.get_choice(this, "move top card to bottom? (#{top_card.name})", true, false)
          @move_top_cards_to_bottom(1)
  @ask_for_play_or_draw = =>
    choice = Input.get_choice(@current_player(), "draw or play?", "play", "draw")
    @current_player().skips_draw = true
    if choice == "draw"
      @current_player().skips_draw = false
      @go_to_next_player()
    skip_draw
  @find_initial_turn_idx = =>
    idx = null
    max_cost = -1
    @players.shuffle().forEach (player, player_idx) =>
      player_cost = player.bottom_card_cost()
      if player_cost > max_cost
        idx = player_idx
        max_cost = player_cost
    idx
  @start_game_loop = =>
    @run_turn()
    @go_to_next_player()
  @run_turn = =>
    @draw_step()
    @untap_step()
    @upkeep_step()
    @first_main_step()
    @declare_attackers_step()
    @declare_blockers_step()
    @do_combat_step()
    @second_main_step()
    @end_step()
  @draw_step = =>
    console.log("in draw step")
  @untap_step = =>
    console.log("in untap step")
  @upkeep_step = =>
    console.log("in upkeep step")
  @first_main_step = =>
    console.log("in first_main step")
  @declare_attackers_step = =>
    console.log("in declare_attackers step")
  @declare_blockers_step = =>
    console.log("in declare_blockers step")
  @do_combat_step = =>
    console.log("in do_combat step")
  @second_main_step = =>
    console.log("in second_main step")
  @end_step = =>
    console.log("in end step")
  @end_game = =>
    @players.forEach (player) =>
      player.deck = [
        player.deck...,
        player.hand...,
        player.graveyard...,
        player.exile...
      ].shuffle().filter (card) =>
        card.is_counter
    this
).apply {}
