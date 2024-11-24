extends Node3D
@onready var game_esc_menu: Control = $game_esc_menu
@export var sensitivity = 0.1
signal hit
signal stand
signal bust
signal reset_game
#@onready var player_camera: Camera3D = $camera/player_camera
@onready var score_label: Label = $score_label
@onready var playing: Control = $playing
@onready var restart: Control = $restart

var target_rotation = Vector3.ZERO
var player_is_in_menu = false
var cards = []
var score_label_text = "Score: {score} / Alt Score: {alt_score}"
var player_score = 0
var alt_player_score = 0
var player_won = false
var player_lost = false


func _ready() -> void:
	game_esc_menu.visible = false
	bust.connect(player_busted)
	score_label.text = score_label_text.format(
		{"score": player_score, "alt_score": alt_player_score}
	)


func _process(_delta: float) -> void:
	if player_won or player_lost:
		playing.visible = false
		restart.visible = true


func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		game_esc_menu.visible = true
		player_is_in_menu = true


func set_score(score: int, alt_score: int):
	player_score = score
	alt_player_score = alt_score
	score_label.text = score_label_text.format(
		{"score": player_score, "alt_score": alt_player_score}
	)
	if player_score > 21 and alt_player_score > 21:
		bust.emit()

	#if event is InputEventMouseMotion && !player_is_in_menu:
	#target_rotation.x -= event.relative.y * sensitivity * 0.01
	#target_rotation.y -= event.relative.x * sensitivity * 0.01
	#target_rotation.x = clamp(target_rotation.x, deg_to_rad(-89), deg_to_rad(89))


#func _process(_delta):
#rotation.y = lerp(rotation.y, target_rotation.y, 0.1)
#var camera_pitch = lerp(player_camera.rotation.x, target_rotation.x, 0.1)
#
#player_camera.rotation.x = camera_pitch


func _on_resume_button_pressed() -> void:
	game_esc_menu.visible = false
	player_is_in_menu = false


func _on_exit_to_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://blackjack_game/scenes/main_menu.tscn")


func _on_hit_button_pressed() -> void:
	hit.emit()


func _on_stand_button_pressed() -> void:
	stand.emit()


func player_busted():
	playing.visible = false
	restart.visible = true


func _on_reset_pressed() -> void:
	set_score(0, 0)
	reset_game.emit()
