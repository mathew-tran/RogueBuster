extends "res://Scripts/Enemies/Behaviours/EnemyBehaviour.gd"

enum DIRECTION{
	LEFT,
	RIGHT,
	UP,
	DOWN	
}

export(DIRECTION) var enemyDirection = DIRECTION.LEFT

var isLookedAt = true
func Setup():
	moveComponent.lastPosition = enemy.global_position
	moveComponent.targetPosition = enemy.global_position
	moveComponent.moveDirection = Vector2.ZERO
	isLookedAt = true

func CanRun():
	return isLookedAt

func Action(delta):			
	var lookDirection
	match enemyDirection:
		DIRECTION.LEFT:
			lookDirection = Vector2(-1,0)
		DIRECTION.RIGHT:
			lookDirection = Vector2(1,0)
		DIRECTION.UP:
			lookDirection = Vector2(0,-1)
		DIRECTION.DOWN:
			lookDirection = Vector2(0,1)
	moveComponent.lastInputDirection = lookDirection
	isLookedAt = false
	

