extends Node3D

@export var max_hp: float = 100.0
var current_hp: float

@onready var blood_material: ShaderMaterial = $"blood".get_surface_override_material(0)

func _ready():
	current_hp = max_hp
	update_blood_fill()

func take_damage(amount: float):
	current_hp -= amount
	current_hp = max(current_hp, 0) # Prevent negative HP
	update_blood_fill()

func update_blood_fill():
	var fill_value = current_hp / max_hp
	blood_material.set_shader_parameter("fill_amount", fill_value)
