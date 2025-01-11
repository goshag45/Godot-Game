extends StaticBody3D

signal press()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	press.emit()
	pass
