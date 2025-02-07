extends Node3D

var magazine = 20
@export var magazine_capacity = 20
@export var damage = 20

@onready var smg = $"."
@onready var animation = $animation
@onready var smg_mesh = $model
@onready var muzzle_flash = $muzzle_flash
@onready var audio_component = $audio_component

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
		audio_component._play_audio_sfx("smg_shot", 3)
		#muzzle_flash.emitting = true
		if target != null && target.is_in_group("enemy"):
			target.health -= damage
			_emit_blood_splatter(hit_point, smg.global_position)

func _reload():
	# you can spam the reload audio for now - not major issue
	audio_component._play_audio_sfx("reload", 3)
	animation.play("reload")
	magazine = magazine_capacity

func _emit_blood_splatter(hit_pos, gun_pos):
	var blood_splatter_instance = blood_splatter.instantiate()
	add_child(blood_splatter_instance)
	blood_splatter_instance.global_position = hit_pos
	blood_splatter_instance.look_at(gun_pos)
	blood_splatter_instance.emitting = true

func _draw_bullet_decals():
	pass
