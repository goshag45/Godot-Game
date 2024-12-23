extends Node3D

var gun_node

var blood_splatter = preload("res://scenes/blood_splatter.tscn").instantiate() 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _reload(gun_node):
	gun_node.animation.play("reload")
	#play reload audio
	magazine = 60

func _emit_blood_splatter():
	pass

func _paint_bullet_hole_decal():
	pass
