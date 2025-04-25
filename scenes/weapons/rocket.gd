extends Node3D

@export var speed: float = 40.0
@export var lifetime: float = 5.0

var velocity: Vector3

func _ready():
	# Schedule auto-despawn
	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _physics_process(delta):
	position += velocity * delta
	look_at(position + velocity.normalized(), Vector3.UP)

func _on_area_entered(area: Area3D) -> void:
	explode()

func _on_body_entered(body: Node3D) -> void:
	explode()

func explode():
	# play explosion, deal damage, etc.
	queue_free()
