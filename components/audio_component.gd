extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _play_audio_sfx(sound_name: String):
	var sound = AudioStreamPlayer.new()
	sound.stream = load("res://audio/" + sound_name + ".mp3")
	get_tree().root.add_child(sound)
	sound.bus = &"SFX"
	sound.play()
	await sound.finished
	sound.queue_free()
