extends "res://Scripts/PlayerItems/PlayerItem.gd"

export(int) var healAmount

func Use():
	var player = get_tree().get_nodes_in_group("Player")[0].health.Heal(healAmount)
