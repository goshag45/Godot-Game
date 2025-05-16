extends MeshInstance3D

@export var spawn_area : Area3D
@export var aura_collision : CollisionShape3D
@export var gore_ball : PackedScene
@export var cockroach : PackedScene
@export var enemy_manager : Node3D

var torus_centre
var spawn_pos : Vector3
var ball_count : int = 50

func _ready() -> void:
	torus_centre = self.global_transform.origin

func _physics_process(_delta: float) -> void:
	pass

func _on_thedavy_da_aura() -> void:
	for x in ball_count:
		spawn_pos = get_random_point_in_torus(torus_centre, 40.0, 25.0)
		var enemy = cockroach.instantiate()
		get_parent().get_parent().add_child(enemy)
		enemy_manager.gore_ball_counter += 1
		enemy.global_position = spawn_pos

func get_random_point_in_torus(origin: Vector3, major_radius: float, minor_radius: float) -> Vector3:
	var angle1 = randf() * TAU  # angle around main ring
	var angle2 = randf() * TAU  # angle around tube
	
	var x = (major_radius + minor_radius * cos(angle2)) * cos(angle1)
	var z = (major_radius + minor_radius * cos(angle2)) * sin(angle1)
	var y = minor_radius * sin(angle2)
	
	return origin + Vector3(x, y, z)
