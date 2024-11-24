extends Node3D
@onready var playing_card: PackedScene = preload("res://blackjack_game/scenes/playing_card.tscn")


func _ready():
	for card in range(1, 52):
		var new_playing_card = playing_card.instantiate()
		add_child(new_playing_card)
		global_position.y += card / 100
		new_playing_card.rotation_degrees = Vector3(180, 0, 0)
