extends Node3D

@export_category("Weapon Stats")
@export var magazine_capacity = 6
@export var damage = 50
@export var fire_mode = 1
@export var shoot_sound = "revolver_shoot"
@export var reload = "reload"
@export var shoot_volume = 5

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
