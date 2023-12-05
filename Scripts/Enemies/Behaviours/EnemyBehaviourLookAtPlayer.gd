extends "res://Scripts/Enemies/Behaviours/EnemyBehaviour.gd"

var isLookedAt = true
func Setup():
	moveComponent.lastPosition = enemy.global_position
	moveComponent.targetPosition = enemy.global_position
	moveComponent.moveDirection = Vector2.ZERO
	isLookedAt = true

func CanRun():
	return isLookedAt

func Action(delta):		
	if player == null:
		pass
		
	var angle = rad2deg((player.global_position - enemy.global_position).angle())
	
	var lookDirection
	if angle <= 45.0 and angle >= -45.0:
		lookDirection = Vector2(1,0)
	elif angle >= 45 and angle < 135:
		lookDirection = Vector2(0,1)
	elif angle < -45 and angle >= -135:
		lookDirection = Vector2(0,-1)
	else:
		lookDirection = Vector2(-1,0)
	moveComponent.lastInputDirection = lookDirection
	isLookedAt = false

