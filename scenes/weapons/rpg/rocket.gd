extends Node3D

@export var speed: float = 25.0
@export var lifetime: float = 5.0
@export var explosion : PackedScene
@export var collision_ray : RayCast3D

var velocity: Vector3
var exploded

func _ready():
	# Schedule auto-despawn
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	global_position += velocity * delta

	var target_position = position + velocity.normalized()
	var up = Vector3.UP

	if abs(velocity.normalized().dot(up)) > 0.99:
		up = Vector3.FORWARD  # Pick another up vector if too parallel

	look_at(target_position, up)
	
	collision_ray.force_raycast_update()
	if collision_ray.is_colliding():
		explode()

func explode():
	if exploded:
		return
	exploded = true
	
	var spawn_position = global_transform.origin
	var explosion_instance = explosion.instantiate()
	get_tree().current_scene.add_child(explosion_instance)
	explosion_instance.global_transform.origin = spawn_position
	queue_free()
