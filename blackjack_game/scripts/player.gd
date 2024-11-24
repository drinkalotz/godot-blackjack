extends Node3D
@onready var game_esc_menu: Control = $game_esc_menu
@export var sensitivity = 0.1  
#@onready var player_camera: Camera3D = $camera/player_camera

var target_rotation = Vector3.ZERO
var player_is_in_menu = false
var cards = []

func _ready() -> void:
	game_esc_menu.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		game_esc_menu.visible = true
		player_is_in_menu = true


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
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	game_esc_menu.visible = false
	player_is_in_menu = false

		



func _on_exit_to_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://blackjack_game/scenes/main_menu.tscn")
