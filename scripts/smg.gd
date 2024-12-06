extends Node3D

@export var revolver_gunshot = preload("res://audio/smg_shot.mp3")
@export var mag_size = 60

@onready var anim_shoot = $AnimationPlayer
@onready var smg_mesh = $model
@onready var muzzle_flash = $muzzle_flash

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _shoot():
	if !anim_shoot.is_playing():
		mag_size -= 1
		anim_shoot.play("smg_shoot")
		_play_shoot_audio()
		muzzle_flash.emitting = true

func _play_shoot_audio():
	var shoot_sound = AudioStreamPlayer.new()
	shoot_sound.stream = load("res://audio/smg_shot.mp3")
	#shoot_sound.set_volume_db(-6.0)
	add_child(shoot_sound)
	shoot_sound.bus = &"SFX"
	shoot_sound.play()
	await shoot_sound.finished
	shoot_sound.queue_free()
