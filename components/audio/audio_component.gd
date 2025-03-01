extends Node3D

func _play_audio_sfx(sound_name: String, volume: float):
	var sound = AudioStreamPlayer.new()
	sound.stream = load("res://audio/" + sound_name + ".mp3")
	sound.volume_db =  linear_to_db(volume)
	get_tree().root.add_child(sound)
	sound.bus = &"SFX"
	sound.play()
	await sound.finished
	sound.queue_free()

func _play_random_sfx(sound_array: Array, volume: float):
	var sound = AudioStreamPlayer.new()
	var random_sound = sound_array.pick_random()
	sound.stream = load("res://audio/" + random_sound + ".mp3")
	sound.volume_db =  linear_to_db(volume)
	get_tree().root.add_child(sound)
	sound.bus = &"SFX"
	sound.play()
	await sound.finished
	sound.queue_free()
