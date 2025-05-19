extends Node3D

@export var speed: float = 25.0
@export var lifetime: float = 5.0
@export var explosion : PackedScene

var velocity: Vector3
var exploded

func _ready():
	# Schedule auto-despawn
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	position += velocity * delta

	var target_position = position + velocity.normalized()
	var up = Vector3.UP

	if abs(velocity.normalized().dot(up)) > 0.99:
		up = Vector3.FORWARD  # Pick another up vector if too parallel

	look_at(target_position, up)

func _on_collision_area_area_entered(_area: Area3D) -> void:
	explode()

func _on_collision_area_body_entered(body: Node3D) -> void:
	#if body.is_in_group("player"):
		#return
	explode()

func explode():
	if exploded:
		return
	exploded = true
	
	var spawn_position = global_transform.origin
	var explosion_instance = explosion.instantiate()
	get_tree().current_scene.add_child(explosion_instance)
	explosion_instance.origin = spawn_position
	explosion_instance.global_transform.origin = spawn_position
	queue_free()
