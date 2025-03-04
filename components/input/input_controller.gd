extends Node

@onready var pause_menu = $".."

var is_paused : bool = false

func _process(_delta: float) -> void:
	_pause_game()

func _pause_game():
	# press escape to show mouse
	if Input.is_action_just_pressed("escape"):
		get_tree().paused = !is_paused
		is_paused = !is_paused
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			pause_menu.show()
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			pause_menu.hide()
