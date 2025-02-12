extends Control

@onready var pause_menu = $"."

func ready():
	set_process_input(true) 
	pass
	
func _on_play_pressed() -> void:
	pause_menu.hide()
	get_tree().paused = false
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
