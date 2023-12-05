extends "res://Scripts/PlayerItems/PlayerItem.gd"

func Use():
	var player = get_tree().get_nodes_in_group("Player")[0]
	player.health.AddHealth(15)
	player.health.Heal(15)
	player.movement.speed -= 50
	if player.movement.speed < 100:
		player.movement.speed = 100
