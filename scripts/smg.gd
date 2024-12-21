extends Node3D

@export var revolver_gunshot = preload("res://audio/smg_shot.mp3")
@export var magazine = 60
@export var damage = 20

@onready var animation = $animation
@onready var smg_mesh = $model
@onready var muzzle_flash = $muzzle_flash

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if magazine <= 0:
		_reload()
	pass

func _shoot(target):
	if !animation.is_playing():
		magazine -= 1
		animation.play("smg_shoot")
		_play_shoot_audio()
		muzzle_flash.emitting = true
		if target != null && target.is_in_group("enemy"):
			target.health -= damage

func _play_shoot_audio():
	var shoot_sound = AudioStreamPlayer.new()
	shoot_sound.stream = load("res://audio/smg_shot.mp3")
	#shoot_sound.set_volume_db(-6.0)
	add_child(shoot_sound)
	shoot_sound.bus = &"SFX"
	shoot_sound.play()
	await shoot_sound.finished
	shoot_sound.queue_free()

func _reload():
	animation.play("reload")
	#play reload audio
	magazine = 60
