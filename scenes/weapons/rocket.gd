extends Node3D

@export var speed: float = 40.0
@export var lifetime: float = 5.0

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
	# play explosion, deal damage, etc.
	if not armed:
		return
	queue_free()
