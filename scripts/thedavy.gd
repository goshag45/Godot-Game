extends CharacterBody3D

@onready var thedavy = $"."
@onready var audio_component = $audio_component
@onready var dialogue_component = $dialogue_component

signal talk()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	thedavy.rotate_y(_delta)
	pass

func interact():
	audio_component._play_audio_sfx("icanseeyou", 10.0)
	dialogue_component._showdialogue("i can see you")
	talk.emit()
	pass
