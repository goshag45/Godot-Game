extends Node3D

func _play_audio_sfx(sound_name: String):
	var sound = AudioStreamPlayer.new()
	sound.stream = load("res://audio/" + sound_name + ".mp3")
	print("res://audio/" + sound_name + ".mp3")
	get_tree().root.add_child(sound)
	sound.bus = &"SFX"
	sound.play()
	await sound.finished
	sound.queue_free()
