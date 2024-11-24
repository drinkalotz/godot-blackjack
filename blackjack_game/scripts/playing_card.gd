extends Node3D
const texture_scale = Vector3(0.9, 0.9, 0.9)
const texture_offset = Vector3(0.5, 0.5, 0.5)
@onready var front: MeshInstance3D = $front
const cards = {
	"CLUBS_2": preload("res://assets/cards/card_clubs_02.png"),
	"CLUBS_3": preload("res://assets/cards/card_clubs_03.png"),
	"CLUBS_4": preload("res://assets/cards/card_clubs_04.png"),
	"CLUBS_5": preload("res://assets/cards/card_clubs_05.png"),
	"CLUBS_6": preload("res://assets/cards/card_clubs_06.png"),
	"CLUBS_7": preload("res://assets/cards/card_clubs_07.png"),
	"CLUBS_8": preload("res://assets/cards/card_clubs_08.png"),
	"CLUBS_9": preload("res://assets/cards/card_clubs_09.png"),
	"CLUBS_10": preload("res://assets/cards/card_clubs_10.png"),
	"CLUBS_J": preload("res://assets/cards/card_clubs_J.png"),
	"CLUBS_Q": preload("res://assets/cards/card_clubs_Q.png"),
	"CLUBS_K": preload("res://assets/cards/card_clubs_K.png"),
	"CLUBS_A": preload("res://assets/cards/card_clubs_A.png"),
	"DIAMONDS_2": preload("res://assets/cards/card_diamonds_02.png"),
	"DIAMONDS_3": preload("res://assets/cards/card_diamonds_03.png"),
	"DIAMONDS_4": preload("res://assets/cards/card_diamonds_04.png"),
	"DIAMONDS_5": preload("res://assets/cards/card_diamonds_05.png"),
	"DIAMONDS_6": preload("res://assets/cards/card_diamonds_06.png"),
	"DIAMONDS_7": preload("res://assets/cards/card_diamonds_07.png"),
	"DIAMONDS_8": preload("res://assets/cards/card_diamonds_08.png"),
	"DIAMONDS_9": preload("res://assets/cards/card_diamonds_09.png"),
	"DIAMONDS_10": preload("res://assets/cards/card_diamonds_10.png"),
	"DIAMONDS_J": preload("res://assets/cards/card_diamonds_J.png"),
	"DIAMONDS_Q": preload("res://assets/cards/card_diamonds_Q.png"),
	"DIAMONDS_K": preload("res://assets/cards/card_diamonds_K.png"),
	"DIAMONDS_A": preload("res://assets/cards/card_diamonds_A.png"),
	"HEARTS_2": preload("res://assets/cards/card_hearts_02.png"),
	"HEARTS_3": preload("res://assets/cards/card_hearts_03.png"),
	"HEARTS_4": preload("res://assets/cards/card_hearts_04.png"),
	"HEARTS_5": preload("res://assets/cards/card_hearts_05.png"),
	"HEARTS_6": preload("res://assets/cards/card_hearts_06.png"),
	"HEARTS_7": preload("res://assets/cards/card_hearts_07.png"),
	"HEARTS_8": preload("res://assets/cards/card_hearts_08.png"),
	"HEARTS_9": preload("res://assets/cards/card_hearts_09.png"),
	"HEARTS_10": preload("res://assets/cards/card_hearts_10.png"),
	"HEARTS_J": preload("res://assets/cards/card_hearts_J.png"),
	"HEARTS_Q": preload("res://assets/cards/card_hearts_Q.png"),
	"HEARTS_K": preload("res://assets/cards/card_hearts_K.png"),
	"HEARTS_A": preload("res://assets/cards/card_hearts_A.png"),
	"SPADES_2": preload("res://assets/cards/card_spades_02.png"),
	"SPADES_3": preload("res://assets/cards/card_spades_03.png"),
	"SPADES_4": preload("res://assets/cards/card_spades_04.png"),
	"SPADES_5": preload("res://assets/cards/card_spades_05.png"),
	"SPADES_6": preload("res://assets/cards/card_spades_06.png"),
	"SPADES_7": preload("res://assets/cards/card_spades_07.png"),
	"SPADES_8": preload("res://assets/cards/card_spades_08.png"),
	"SPADES_9": preload("res://assets/cards/card_spades_09.png"),
	"SPADES_10": preload("res://assets/cards/card_spades_10.png"),
	"SPADES_J": preload("res://assets/cards/card_spades_J.png"),
	"SPADES_Q": preload("res://assets/cards/card_spades_Q.png"),
	"SPADES_K": preload("res://assets/cards/card_spades_K.png"),
	"SPADES_A": preload("res://assets/cards/card_spades_A.png")
}

var card_score = 0
var card_score_alt = 0


func set_card(card_path: String, card_score_out: int, card_alt_score_out: int):
	var front_material = StandardMaterial3D.new()
	var texture = cards[card_path]
	card_score = card_score_out
	card_score_alt = card_alt_score_out
	front_material.albedo_texture = texture
	front_material.uv1_triplanar = true
	front_material.uv1_offset = texture_offset
	front_material.uv1_scale = texture_scale
	front.material_override = front_material
