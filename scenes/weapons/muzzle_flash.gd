extends Node3D

@export var emit = false
@onready var particle = $particle
@onready var light = $light

func ready():
	light.visible = false

func process():
	particle.emitting = false
	_emit()

func _emit():
	if emit:
		particle.emitting = true
