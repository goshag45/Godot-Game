extends Camera3D
#https://www.youtube.com/watch?v=gL0iibY6-Fg
@export var follow_target: NodePath

@onready var player = $"../.."
@onready var camera = $"."

var target : Node3D
var update = false
var gt_prev : Transform3D
var gt_current : Transform3D

func _unhandled_input(event: InputEvent) -> void:
#func handle_mouse_camera(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		player.rotate_y(-event.relative.x * player.SENSITIVITY)
		camera.rotate_x(-event.relative.y * player.SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

#func _ready():
	#set_as_top_level(true)
	#target = get_node_or_null(follow_target)
	#
	#if target == null:
		#target = get_parent()
	#global_transform = target.global_transform
	#
	#gt_prev = target.global_transform
	#gt_current = target.global_transform
	#
#func update_transform():
	#gt_prev = gt_current
	#gt_current = target.global_transform
#
#func _process(_delta):
	#if update:
		#update_transform()
		#update = false
#
	#var f = clamp(Engine.get_physics_interpolation_fraction(), 0, 1)
	#var interpolated_transform = gt_prev.interpolate_with(gt_current, f)
	## Preserve the current camera rotation
	#interpolated_transform.basis = Basis().rotated(rotation, 0)
	#global_transform = interpolated_transform
#
	#
#func _physics_process(_delta):
	#update = true
