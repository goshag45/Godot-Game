extends Control

func _on_play_pressed() -> void:
	get_tree().paused = false
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
