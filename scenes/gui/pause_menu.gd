extends Control

@onready var pause_menu = $"."
@onready var input_controller = $input_controller

func ready():
	set_process_input(true)
	pass
	
func _on_play_pressed() -> void:
	_unpause_game()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _unpause_game():
	input_controller._pause_game()
	input_controller.is_paused = false
	pause_menu.hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
