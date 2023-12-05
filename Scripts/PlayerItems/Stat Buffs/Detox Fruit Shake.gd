extends "res://Scripts/PlayerItems/PlayerItem.gd"

func Use():
	var player = get_tree().get_nodes_in_group("Player")[0]	
	player.health.TakeDamage(int(player.health.health / 2))
	player.movement.speed += 50
	if player.movement.speed > 700:
		player.movement.speed = 700
