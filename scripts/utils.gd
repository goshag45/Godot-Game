extends Node

class_name utils

static func get_child_in_group(parent: Node, group_name: String) -> Node:
	for child in parent.get_children():
		if child.is_in_group(group_name):
			return child
	return null
