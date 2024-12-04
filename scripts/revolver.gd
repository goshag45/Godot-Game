extends Node3D

@onready var revolver_anim = $AnimationPlayer
@onready var revolver_barrel = $gun_barrel
@onready var revolver = $"."

@export var revolver_gunshot = preload("res://audio/revolver_gunshot.mp3")
@export var mag_size = 6

var bullet = load("res://scenes/bullet.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _shoot():
	mag_size -= 1
	
	if !revolver_anim.is_playing():
		revolver_anim.play("shoot_revolver")
		var bullet_instance = bullet.instantiate()
		get_parent().add_child(bullet_instance)
		bullet_instance.global_position = revolver.global_position
		
	var revolver_shoot = AudioStreamPlayer3D.new()
	revolver_shoot.stream = load("res://audio/revolver_gunshot.mp3")
	revolver_shoot.position = revolver_barrel.position
	revolver_shoot.set_volume_db(-6.0)
	add_child(revolver_shoot)
	revolver_shoot.bus = &"SFX"
	revolver_shoot.play()
	await revolver_shoot.finished
	revolver_shoot.queue_free()
