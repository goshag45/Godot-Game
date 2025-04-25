extends Area3D

@export var radius: float = 4.0
@export var damage: int = 100
@export var force: float = 50.0
@export var lifetime: float = 2.0  # time before it's freed

var origin: Vector3

func _ready():
	$explosion_radius.shape.radius = radius
	$timer.wait_time = lifetime
	$timer.start()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node):
	if body.is_in_group("enemy"):
		body.health -= damage

	await get_tree().physics_frame
	await get_tree().physics_frame
	apply_force()

func _on_timer_timeout() -> void:
	queue_free()

func apply_force() -> void:
	for body in $".".get_overlapping_bodies():
		var body_pos = body.global_position
		var force_div = 400.0
		if body is CharacterBody3D:
			body_pos.y =+ 1.0
			force_div = 150.0
		elif body is RigidBody3D:
			force_div = max(0.01, body.mass)
		var force_dir = self.global_position.direction_to(body_pos)
		var body_dist = (body_pos - self.global_position).length()
		var explosion_vec = lerp(0.0, force, 1.0 - clampf((body_dist / radius), 0.0, 1.0)) / force_div * force_dir
		if body is RigidBody3D:
			body.apply_impulse(explosion_vec * force)
		elif body is CharacterBody3D:
			body.velocity += explosion_vec * force
