extends Node

class_name utils

static func get_child_in_group(parent: Node, group_name: String) -> Node:
	for child in parent.get_children():
		if child.is_in_group(group_name):
			return child
	return null

static func start_and_wait_timer(current_node: Node, duration: float, one_shot: bool) -> Timer:
	var timer := Timer.new()
	current_node.add_child(timer)
	timer.wait_time = duration
	timer.one_shot = one_shot
	timer.start() # ✅ You need this!
	return timer
