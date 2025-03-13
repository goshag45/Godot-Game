extends RayCast3D

@onready var interact_popup = $"../../../gui_layer/in_game_gui/interactable_message"

func _process(_delta: float) -> void:
	var collider = self.get_collider()
	
	if self.is_colliding() && collider != null:
		if global_signals.is_dialogue_open:
			interact_popup.hide()
		if collider.is_in_group("interactable_press") and global_signals.is_dialogue_open == false:
			interact_popup.show()
			if Input.is_action_just_pressed("interact"):
				collider.interact()
	else:
		interact_popup.hide()
