extends Node3D
@onready var main_menu_control: Control = $Camera3D/main_menu_control
@onready var settings_control: Control = $Camera3D/settings_control


func _ready() -> void:
	main_menu_control.visible = true
	settings_control.visible = false


func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://blackjack_game/scenes/game_table.tscn")


func _on_fullscreen_toggled(toggled_on: bool) -> void:
	match toggled_on:
		true:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		false:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		_:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_settings_button_pressed() -> void:
	main_menu_control.visible = false
	settings_control.visible = true


func _on_back_button_pressed() -> void:
	main_menu_control.visible = true
	settings_control.visible = false


func _on_exit_button_pressed() -> void:
	get_tree().quit()
