extends Control

@export var hover_sound: AudioStream  # Drag & drop a sound file in the Inspector
@export_range(-30.0, 6.0, 0.1) var volume_db: float = 0.0  # Volume slider in dB

@onready var player: AudioStreamPlayer = AudioStreamPlayer.new()

func _ready():
	add_child(player)  # Attach the sound player dynamically
	player.stream = hover_sound
	player.volume_db = volume_db  # Apply volume setting

	if has_signal("mouse_entered"):
		connect("mouse_entered", _on_mouse_entered)

func _on_mouse_entered():
	if player and hover_sound:
		player.play()

# courtesy of chatgpt
