extends StaticBody3D

@onready var audio_component = $audio_component
@onready var dialogue_component = $dialogue_component

signal press()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func interact():
	press.emit()
	audio_component._play_audio_sfx("woom", 8)
	dialogue_component._show_dialogue_timeout("woom...", 0.5)
