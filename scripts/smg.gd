extends Node3D

@export var magazine = 60
@export var damage = 20

@onready var smg = $"."
@onready var animation = $animation
@onready var smg_mesh = $model
@onready var muzzle_flash = $muzzle_flash

var blood_splatter = preload("res://scenes/blood_splatter.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# this stops blood splatter emission currently
	if magazine <= 0:
		_reload()
	pass

func _shoot(target, hit_point):
	if !animation.is_playing():
		magazine -= 1
		animation.play("smg_shoot")
		_play_audio("smg_shot")
		muzzle_flash.emitting = true
		if target != null && target.is_in_group("enemy"):
			target.health -= damage
			_emit_blood_splatter(hit_point, smg.global_position)

func _reload():
	#if !animation.is_playing():
	# you can spam the reload audio for now - not major issue
	_play_audio("reload")
	animation.play("reload")
	magazine = 60

func _emit_blood_splatter(hit_pos, gun_pos):
	var blood_splatter_instance = blood_splatter.instantiate()
	add_child(blood_splatter_instance)
	blood_splatter_instance.global_position = hit_pos
	blood_splatter_instance.look_at(gun_pos)
	blood_splatter_instance.emitting = true

func _play_audio(sound_name: String):
	var sound = AudioStreamPlayer.new()
	sound.stream = load("res://audio/" + sound_name + ".mp3")
	add_child(sound)
	sound.bus = &"SFX"
	sound.play()
	await sound.finished
	sound.queue_free()

func _draw_bullet_decals():
	pass
