extends "res://Scripts/Enemies/Behaviours/EnemyBehaviour.gd"

enum DIRECTION{
	LEFT,
	RIGHT,
	UP,
	DOWN	
}

var moves = 1

export(DIRECTION) var enemyDirection = DIRECTION.LEFT

export var maxMoves = 3

func Setup():
	moves = maxMoves
	moveComponent.lastPosition = enemy.global_position
	moveComponent.targetPosition = enemy.global_position
	moveComponent.moveDirection = Vector2.ZERO
	
func CanRun():
	return moves >= 0 || moveComponent.IsAtTargetPosition(enemy)

# Run this in process of the enemy	
func Action(delta):		
	moveComponent.Update(enemy, self, delta)

func GetMoveDirectionInput():

	moves -= 1
	match enemyDirection:
		DIRECTION.LEFT:
			return Vector2(-1,0)
		DIRECTION.RIGHT:
			return Vector2(1,0)
		DIRECTION.UP:
			return Vector2(0,-1)
		DIRECTION.DOWN:
			return Vector2(0,1)
	
	return Vector2.ZERO
