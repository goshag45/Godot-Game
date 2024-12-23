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
func _process(delta: float) -> void:
	if magazine <= 0:
		_reload()
	pass

func _shoot(target, hit_point, aim_ray):
	if !animation.is_playing():
		magazine -= 1
		animation.play("smg_shoot")
		_play_shoot_audio()
		muzzle_flash.emitting = true
		if target != null && target.is_in_group("enemy"):
			target.health -= damage
		_emit_blood_splatter(hit_point, smg_mesh.global_position, aim_ray)

func _play_shoot_audio():
	var shoot_sound = AudioStreamPlayer.new()
	shoot_sound.stream = load("res://audio/smg_shot.mp3")
	add_child(shoot_sound)
	shoot_sound.bus = &"SFX"
	shoot_sound.play()
	await shoot_sound.finished
	shoot_sound.queue_free()

func _reload():
	animation.play("reload")
	#play reload audio
	magazine = 60

func _emit_blood_splatter(hit_pos, gun_pos, aim_ray):
	var blood_splatter_instance = blood_splatter.instantiate()
	add_child(blood_splatter_instance)
	blood_splatter_instance.position = hit_pos
	blood_splatter_instance.look_at(gun_pos)
	blood_splatter_instance.emitting = true

func _draw_bullet_decals():
	pass
