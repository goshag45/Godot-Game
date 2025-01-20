extends Node3D

var deathbox: Area3D = null

func _ready() -> void:
	#get_tree().change_scene_to_file("res://scenes/level_1.tscn")
	# Wait for the new scene to load before trying to find the deathbox
	call_deferred("_setup_deathbox_signal")

func _setup_deathbox_signal() -> void:
	# Safely locate the deathbox node after the scene is loaded
	deathbox = get_tree().get_first_node_in_group("deathbox")
	if deathbox:
		deathbox.area_entered.connect(_on_deathbox_area_entered)
		print("connected")
	else:
		print("Error: Deathbox node not found")

func _on_deathbox_area_entered(area: Area3D) -> void:
	print("entered")

func _process(delta: float) -> void:
	pass
