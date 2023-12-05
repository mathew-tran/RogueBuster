extends "res://Scripts/Enemies/Behaviours/EnemyBehaviour.gd"


var middlePoint

func Setup():
	middlePoint = get_tree().get_nodes_in_group("MiddlePoint")[0]
	middlePoint.position = middlePoint.position.snapped(Vector2(64, 64))
	moveComponent.lastPosition = enemy.global_position
	moveComponent.targetPosition = enemy.global_position
	moveComponent.moveDirection = Vector2.ZERO
	
# Called when the node enters the scene tree for the first time.
func CanRun():
	return GetMoveDirectionInput() != Vector2(0,0)

# Run this in process of the enemy	
func Action(delta):		
	moveComponent.Update(enemy, self, delta)

func GetMoveDirectionInput():
	if enemy.position.distance_to(middlePoint.global_position) < 3:
		return Vector2(0,0)
	var angle = rad2deg((middlePoint.global_position - enemy.global_position).angle())
	if angle < 45.0 and angle > -45.0:
		return Vector2(1,0)
	elif angle >= 45 and angle < 135:
		return Vector2(0,1)
	elif angle < -45 and angle >= -135:
		return Vector2(0,-1)
	else:
		return Vector2(-1,0)
	
