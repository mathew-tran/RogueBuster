extends Node2D

func _ready():
	var children = get_children()
	for child in children:
		child.global_position = child.global_position.snapped(Vector2(32, 32))
		child.visible = false
