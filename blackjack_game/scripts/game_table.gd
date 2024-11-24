extends Node3D
@onready var player_node: PackedScene = preload("res://blackjack_game/scenes/player.tscn")
@onready var dealer_node: PackedScene = preload("res://blackjack_game/scenes/dealer.tscn")
@onready var playing_deck_model: PackedScene = preload("res://blackjack_game/scenes/playing_deck.tscn")
@onready var spawn_1: Node3D = $spawn1
@onready var dealer_spawn: Node3D = $dealer_spawn
@onready var card_node: PackedScene = preload('res://blackjack_game/scenes/playing_card.tscn')
@onready var playing_deck_spawn: Node3D = $playing_deck_spawn
var card_dir = DirAccess.open("res://assets/cards") 
@onready var outcome: Label = $outcome
@onready var dealer_score_label: Label = $dealer_score
var score_label_text = "Dealer Score: {score} / Alt Score: {alt_score}"

var files = card_dir.get_files()
var current_playing_deck = []
var is_dealer_playing = false

var game_state = {
	"players": [],
}



func _ready() -> void:
	current_playing_deck = create_deck()
	var new_player = player_node.instantiate()
	var dealer = dealer_node.instantiate()
	var playing_deck = playing_deck_model.instantiate()
	new_player.hit.connect(player_hit)
	new_player.stand.connect(player_stand)
	new_player.bust.connect(player_busted)
	new_player.reset_game.connect(reset_game)
	dealer.bust.connect(dealer_busted)
	dealer.dealer_at_limit.connect(dealer_at_limit)
	game_state.players.append({"entity": new_player, "spawn": spawn_1, "cards": []})
	game_state.players.append({"entity": dealer, "spawn": dealer_spawn, "cards": []})
	add_child(dealer)
	add_child(new_player)
	add_child(playing_deck)
	playing_deck.global_position = playing_deck_spawn.global_position
	new_player.global_position = spawn_1.global_position
	dealer.global_position = dealer_spawn.global_position
	deal_cards()
	


func _process(_delta: float) -> void:
	var dealer = game_state.players[1]
	var dealer_card = dealer.cards[0]
	if not is_dealer_playing:
		dealer_score_label.text = score_label_text.format({"score": dealer_card.card_score, "alt_score": dealer_card.card_score_alt})
	else:
		dealer_score_label.text = score_label_text.format({"score": dealer.entity.dealer_score, "alt_score": dealer.entity.alt_dealer_score})
	
func deal_cards():
	for player in game_state.players:
		while player.cards.size() < 2:
			var random_index = randi() % current_playing_deck.size()
			var random_card = current_playing_deck[random_index]
			current_playing_deck.remove_at(random_index)
			receive_card(random_card, player, player.entity.name == "dealer")
			
func receive_card(card, player, is_dealer: bool):
	var new_card = card_node.instantiate()
	add_child(new_card)
	new_card.set_card(card.card, card.score, card.alt_score)
	var card_spawn_node = player.spawn.get_node("card_spawn").global_position
	var card_count = player.cards.size()
	var offset_x: float = card_count * 0.025
	var offset_y: float = -0.002
	var offset_z: float = 0.001  
	new_card.global_position = Vector3(
		card_spawn_node.x + offset_x,
		card_spawn_node.y + offset_y,  
		card_spawn_node.z - offset_z
	)
	player.cards.append(new_card)
	var sum_score = 0
	var sum_alt_score = 0
	for player_card in player.cards:
		sum_score += player_card.card_score
		sum_alt_score += player_card.card_score_alt if player_card.card_score_alt > 0 else player_card.card_score
	player.entity.set_score(sum_score, sum_alt_score)
	if is_dealer and player.cards.size() == 2:
		new_card.rotation_degrees = Vector3(180, 0, 0)
	
func create_deck():
	var result = []
	for file in files:
		if valid_card(file):
			var score_string = file.split('_')[2].split('.png')[0]
			var score: int = 0
			var alt_score: int = 0
			if score_string == "J" or score_string == "K" or score_string == "Q":
				score = 10
			elif score_string == "A":
				score = 1
				alt_score = 11
			else:
				score = score_string as int
			result.append({"card": file, "score": score, "alt_score": alt_score, "is_ace": alt_score > 0})
	return result

func valid_card(to_check: String) -> bool:
	return not to_check.contains("back") and not to_check.contains("joker") and not to_check.contains("empty") and not to_check.contains(".import")
	
func player_hit():
	var player = game_state.players[0]
	var random_index = randi() % current_playing_deck.size()
	var random_card = current_playing_deck[random_index]
	current_playing_deck.remove_at(random_index)
	receive_card(random_card, player, player.entity.name == "dealer")
	
func get_max_score(score1: int, score2: int) -> int:
	if score1 > 21 and score2 > 21:
		return min(score1, score2)
	if score1 > 21: 
		return score2
	if score2 > 21:
		return score1
	return max(score1, score2)
func dealer_play():
	is_dealer_playing = true
	var dealer = game_state.players[1]
	var player = game_state.players[0]
	var max_dealer = get_max_score(dealer.entity.dealer_score, dealer.entity.alt_dealer_score)
	var max_player = get_max_score(player.entity.player_score, player.entity.alt_player_score)
	for card in dealer.cards:
		card.rotation_degrees = Vector3(0, 0, 0)
	while dealer.entity.dealer_score != 16 and dealer.entity.alt_dealer_score != 16 and not dealer.entity.is_bust and max_dealer < max_player:
		var random_index = randi() % current_playing_deck.size()
		var random_card = current_playing_deck[random_index]
		current_playing_deck.remove_at(random_index)
		receive_card(random_card, dealer, dealer.entity.name == "dealer")
	if (max_dealer > max_player):
		player_busted()
	elif max_dealer == max_player:
		draw()
func player_stand():
	dealer_play()
func player_busted():
	outcome.text = "Dealer won"
	outcome.visible = true
	game_state.players[0].entity.player_lost = true 
func draw():
	outcome.text = "Draw"
	outcome.visible = true
	game_state.players[0].entity.player_lost = true
	
func dealer_busted():
	outcome.text = "Player won"
	outcome.visible = true
	game_state.players[0].entity.player_won = true
func dealer_at_limit():
	var dealer = game_state.players[1]
	var player = game_state.players[0]
	var max_dealer = max(dealer.entity.dealer_score, dealer.entity.alt_dealer_score)
	var max_player = max(player.entity.player_score, player.entity.alt_player_score)
	if max_dealer > max_player:
		player_busted()
	else:
		dealer_busted()
func reset_game():
	for player in game_state.players:
		for card in player.cards:
			card.queue_free() 
		player.cards.clear()  

	game_state = {
		"players": [],
	}
	get_tree().reload_current_scene()
