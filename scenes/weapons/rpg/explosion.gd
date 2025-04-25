extends Area3D

@export var radius: float = 4.0
@export var damage: int = 100
@export var force: float = 50.0
@export var lifetime: float = 0.2  # time before it's freed

var origin: Vector3

func _ready():
	$explosion_radius.shape.radius = radius
	$timer.wait_time = lifetime
	$timer.start()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node):
	if body.is_in_group("enemy"):
		body.health -= damage
	if body is RigidBody3D:
		var direction = (body.global_transform.origin - origin).normalized()
		body.apply_impulse(direction * force)

func _on_timer_timeout() -> void:
	queue_free()
