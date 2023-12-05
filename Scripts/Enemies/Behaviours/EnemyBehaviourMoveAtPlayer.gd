extends "res://Scripts/Enemies/Behaviours/EnemyBehaviour.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var moves = 1

export var maxMoves = 3

func Setup():
	moves = maxMoves
	moveComponent.lastPosition = enemy.global_position
	moveComponent.targetPosition = enemy.global_position
	moveComponent.moveDirection = Vector2.ZERO
	
# Called when the node enters the scene tree for the first time.
func CanRun():
	return moves >= 0 || moveComponent.IsAtTargetPosition(enemy)

# Run this in process of the enemy	
func Action(delta):		
	moveComponent.Update(enemy, self, delta)

func GetMoveDirectionInput():
	moves -= 1
	var angle = rad2deg((player.global_position - enemy.global_position).angle())
	if angle < 45.0 and angle > -45.0:
		return Vector2(1,0)
	elif angle >= 45 and angle < 135:
		return Vector2(0,1)
	elif angle < -45 and angle >= -135:
		return Vector2(0,-1)
	else:
		return Vector2(-1,0)
	
