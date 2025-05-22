extends Node

const MAX_CONCURRENT := {
	"blood_squelch": 2,
	"death_grunt": 2,
}

const COOLDOWN := {
	"blood_squelch": 0.2,
}

var playing := {}
var last_played := {}

func play_sfx(sound_name: String, volume: float = 1.0):
	var now := Time.get_ticks_msec() / 1000.0
	
	# Cooldown enforcement
	if COOLDOWN.has(sound_name):
		var last_time : float = last_played.get(sound_name, -1000.0)
		if now - last_time < COOLDOWN[sound_name]:
			return
	
	# Concurrency limit enforcement
	var limit : int= MAX_CONCURRENT.get(sound_name, INF)
	var count : int = playing.get(sound_name, 0)
	if count >= limit:
		return
	
	last_played[sound_name] = now
	playing[sound_name] = count + 1

	var player := AudioStreamPlayer.new()
	player.stream = load("res://audio/%s.mp3" % sound_name)
	player.volume_db = linear_to_db(volume)
	player.bus = "SFX"
	get_tree().root.add_child(player)
	player.play()

	player.finished.connect(func ():
		playing[sound_name] = max(0, playing.get(sound_name, 1) - 1)
		player.queue_free()
	)
