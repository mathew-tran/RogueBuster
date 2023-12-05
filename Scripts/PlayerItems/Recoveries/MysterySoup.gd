extends "res://Scripts/PlayerItems/PlayerItem.gd"

export(int) var healAmount

func Use():
	var result = randi() % 2
	var player = get_tree().get_nodes_in_group("Player")[0]
	if result == 1:
		player.health.Heal(healAmount)
	else:
		player.health.TakeDamage(healAmount)
