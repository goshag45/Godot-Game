extends Control

@onready var start_menu = $"."

func ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_play_pressed() -> void:
	start_menu.hide()
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()
