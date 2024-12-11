extends CharacterBody3D

@export var health = 200

func _ready():
	pass

func _physics_process(delta: float) -> void:
	pass

func _process(delta):
	if health <= 0:
		queue_free()
