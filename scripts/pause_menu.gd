extends Control

@onready var pause_menu = $"."
@onready var input_controller = $input_controller

func ready():
	set_process_input(true) 
	pass
	
func _on_play_pressed() -> void:
	input_controller._pause_game()
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
