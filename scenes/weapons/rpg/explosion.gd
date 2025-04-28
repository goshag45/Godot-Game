extends Area3D

@export var radius: float = 6.0
@export var damage: float = 30.0
@export var force: float = 100.0
@export var lifetime: float = 0.05  # time before it's freed

var origin: Vector3
var explosion_vfx = preload("res://scenes/weapons/rpg/simple_explosion_vfx.tscn")

func _ready():
	$explosion_radius.shape.radius = radius
	$timer.wait_time = lifetime
	$timer.start()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body: Node):
	var spawn_position = global_transform.origin
	var vfx_instance = explosion_vfx.instantiate()
	get_tree().current_scene.add_child(vfx_instance)
	vfx_instance.global_transform.origin = spawn_position
	vfx_instance.get_node("animation").play("explode")
	
	if body.is_in_group("enemy"):
		body.health -= damage
	await get_tree().physics_frame
	await get_tree().physics_frame
	apply_force()

func _on_timer_timeout() -> void:
	queue_free()

func apply_force():
	for body in get_overlapping_bodies():
		if not (body is RigidBody3D or body is CharacterBody3D):
			continue
		var body_pos = body.global_position
		if body is CharacterBody3D:
			body_pos.y += 1.0
		var direction = self.global_position.direction_to(body_pos)
		var distance = (body_pos - self.global_position).length()
		var falloff = clamp(1.0 - (distance / radius), 0.1, 1.0)
		var impulse = direction.normalized() * force * falloff
		
		if body is RigidBody3D:
			body.apply_impulse(impulse)
		elif body is CharacterBody3D:
			body.velocity += impulse /5
