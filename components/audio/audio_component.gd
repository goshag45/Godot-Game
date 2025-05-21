extends Node3D

const MAX_CONCURRENT_SFX := 4
const DEATH_SOUND_COOLDOWN := 0.2 # seconds
var active_sfx_count: int = 0
var last_death_sound_time := 0.0

func _play_audio_sfx(sound_name: String, volume: float, use_limit := false):
	var now = Time.get_ticks_msec() / 1000.0
	
	if use_limit:
		if now - last_death_sound_time < DEATH_SOUND_COOLDOWN:
			return
		last_death_sound_time = now
		if active_sfx_count >= MAX_CONCURRENT_SFX:
			return
	
	var sound = AudioStreamPlayer.new()
	#debug
	#print("res://audio/" + sound_name + ".mp3")
	sound.stream = load("res://audio/" + sound_name + ".mp3")
	sound.volume_db =  linear_to_db(volume)
	get_tree().root.add_child(sound)
	
	sound.bus = &"SFX"
	sound.play()
	active_sfx_count += 1
	await sound.finished
	active_sfx_count -= 1
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
