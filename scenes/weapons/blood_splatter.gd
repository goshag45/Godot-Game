extends GPUParticles3D

func ready():
	await get_tree().create_timer(3).timeout
	print("removed")
