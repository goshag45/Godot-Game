extends Control

@onready var start_menu = $"."

var player = preload("res://scenes/player/player.tscn")

func ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_play_pressed() -> void:
	start_menu.hide()
	get_tree().change_scene_to_file("res://scenes/level 2/level_2.tscn")
	var player_instance = player.instantiate()

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()
