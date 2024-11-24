extends Node3D
@onready var player_node: PackedScene = preload("res://blackjack_game/scenes/player.tscn")
@onready var dealer_node: PackedScene = preload("res://blackjack_game/scenes/dealer.tscn")
@onready var spawn_1: Node3D = $spawn1
@onready var dealer_spawn: Node3D = $dealer_spawn
@onready var card_node: PackedScene = preload('res://blackjack_game/scenes/playing_card.tscn')
var card_dir = DirAccess.open("res://assets/cards") 
var files = card_dir.get_files()
var current_playing_deck = []

var game_state = {
	"players": [],
}



func _ready() -> void:
	current_playing_deck = create_deck()
	var new_player = player_node.instantiate()
	var dealer = dealer_node.instantiate()
	game_state.players.append({"entity": new_player, "spawn": spawn_1, "cards": []})
	game_state.players.append({"entity": dealer, "spawn": dealer_spawn, "cards": []})
	add_child(dealer)
	add_child(new_player)
	new_player.global_position = spawn_1.global_position
	dealer.global_position = dealer_spawn.global_position
	deal_cards()
	


func _process(_delta: float) -> void:
	pass
	
func deal_cards():
	for player in game_state.players:
		while player.cards.size() < 2:
			var random_index = randi() % current_playing_deck.size()
			var random_card = current_playing_deck[random_index]
			current_playing_deck.remove_at(random_index)
			receive_card(random_card, player, player.entity.name == "dealer")
			
func receive_card(card: String, player, is_dealer: bool):
	var new_card = card_node.instantiate()
	add_child(new_card)
	new_card.set_card(card)
	player.cards.append(new_card)
	if player.cards.size() == 1:
		new_card.global_position = player.spawn.get_node("left_card_spawn").global_position
		if is_dealer:
			new_card.rotation_degrees = Vector3(180, 0, 0)
	elif player.cards.size() == 2:
		new_card.global_position = player.spawn.get_node("right_card_spawn").global_position
	
func create_deck():
	var result = []
	for file in files:
		if valid_card(file):
			result.append(file)
	return result

func valid_card(to_check: String) -> bool:
	return not to_check.contains("back") and not to_check.contains("joker") and not to_check.contains("empty") and not to_check.contains(".import")
