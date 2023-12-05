extends Sprite

func PlayStable():
	$AnimationPlayer.play("Stable")
	
func PlaySpawn():
	$AnimationPlayer.play("SpawnAnimation")
	
func Set(position):
	global_position = position
	
func _process(delta):
	rotate(15 * delta)
