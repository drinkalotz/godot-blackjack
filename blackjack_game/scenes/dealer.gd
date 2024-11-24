extends Node3D

var cards = []
var score_label_text = "Score: {score} / Alt Score: {alt_score}"
var dealer_score = 0
var alt_dealer_score = 0
signal bust
var is_bust = false
signal dealer_at_limit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
func set_score(score: int, alt_score: int):
	dealer_score = score
	alt_dealer_score = alt_score
	if dealer_score == 16 and alt_dealer_score == 16:
		dealer_at_limit.emit()
	if dealer_score > 21 and alt_dealer_score > 21:
		bust.emit()
		is_bust = true
	#score_label.text = score_label_text.format({"score": player_score, "alt_score": alt_player_score})
