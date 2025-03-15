extends MeshInstance3D

@onready var blood = $blood

var max_health = 100
var current_health = 100

func _ready():
	blood.emitting = true

func update_health(new_health):
	current_health = clamp(new_health, 0, max_health)
	var health_ratio = current_health / max_health

	# Reduce particle amount based on health
	blood.amount = int(health_ratio * 200)

	# Scale blood particle area to make it "sink"
	var shape = blood.process_material.emission_shape
	if shape is BoxShape3D:
		shape.size.y = health_ratio * 0.5  # Shrinks as health drops

	# Turn off particles if no blood left
	blood.emitting = health_ratio > 0
