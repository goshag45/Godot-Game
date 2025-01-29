extends CharacterBody3D

@onready var audio_component = $audio_component

signal talk()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func interact():
	audio_component._play_audio_sfx("icanseeyou")
	talk.emit()
	pass
