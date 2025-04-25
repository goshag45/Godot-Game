extends Node3D

@export var speed: float = 25.0
@export var lifetime: float = 5.0
@export var explosion : PackedScene

var velocity: Vector3
var armed := false

func _ready():
	await get_tree().create_timer(0.05).timeout
	armed = true
	# Schedule auto-despawn
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	position += velocity * delta
	look_at(position + velocity.normalized(), Vector3.UP)

func _on_collision_area_area_entered(area: Area3D) -> void:
	explode()

func _on_collision_area_body_entered(body: Node3D) -> void:
	explode()

func explode():
	if not armed:
		return

	var explosion_instance = explosion.instantiate()
	explosion_instance.origin = global_transform.origin
	explosion_instance.global_transform.origin = global_transform.origin
	get_tree().current_scene.add_child(explosion_instance)
	queue_free()
