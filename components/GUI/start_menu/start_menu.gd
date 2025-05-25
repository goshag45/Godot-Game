extends Control

var player = preload("res://scenes/player/player.tscn")
@export var start_menu : Control
@export var level_select : Control

func ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_play_pressed() -> void:
	start_menu.visible = false
	level_select.visible = true
	#get_tree().change_scene_to_file("res://scenes/level 2/level_2.tscn")
	#get_tree().change_scene_to_file("res://trenchbroom_levels/trenchbroom_map_1.tscn")

func _on_options_pressed() -> void:
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_back_pressed() -> void:
	start_menu.visible = true
	level_select.visible = false

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/level 2/level_2.tscn")
