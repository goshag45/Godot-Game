extends RayCast3D

@onready var interact_popup = $"../../../CanvasLayer/Control/interactable_message"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var collider = self.get_collider()
	
	if self.is_colliding() && collider != null:
		if collider.is_in_group("interactable_press"):
			interact_popup.show()
			if Input.is_action_just_pressed("interact"):
				collider.interact()
	else:
		interact_popup.hide()
