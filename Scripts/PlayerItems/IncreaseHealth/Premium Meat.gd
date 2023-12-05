extends "res://Scripts/PlayerItems/PlayerItem.gd"

export var addHealth = 10
export var healHealth = 10
func Use():
	var player = get_tree().get_nodes_in_group("Player")[0]
	player.health.AddHealth(addHealth)
	player.health.Heal(healHealth)
