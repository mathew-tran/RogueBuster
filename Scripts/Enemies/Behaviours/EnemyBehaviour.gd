extends Node

var enemy
var moveComponent
var player

func _ready():	
	moveComponent = get_parent().get_parent().get_node("MoveComponent")
	
	enemy = get_parent().get_parent()
	player = get_tree().get_nodes_in_group("Player")[0]
	
func CanRun():
	return true

func Action(delta):
	pass
