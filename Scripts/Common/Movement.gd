extends Node

export var speed = 256.0
var tileSize = 64.0

var lastPosition = Vector2()
var targetPosition = Vector2()
var moveDirection = Vector2()

var lastInputDirection = Vector2(1, 0)

var sprite
func _ready():
	sprite = get_node("../Sprite")
	
func Setup(moveObject):
	moveObject.position = moveObject.position.snapped(Vector2(tileSize, tileSize))
	lastPosition = moveObject.position
	targetPosition = moveObject.position

func _process(delta):
	var angle = rad2deg(Vector2(0, 1).angle_to(lastInputDirection))
	sprite.set_rotation_degrees(angle)

func Update(moveObject, inputObject, delta):
	if moveObject.ray.is_colliding():
		moveObject.position = lastPosition
		targetPosition = lastPosition		
	else:		
		moveObject.position += speed * moveDirection * delta			
		if moveObject.position.distance_to(lastPosition) >= tileSize - speed * delta:
			moveObject.position = targetPosition
			moveObject.position.snapped(Vector2(tileSize, tileSize))
	
	# Idle
	if moveObject.position == targetPosition:
		moveObject.position.snapped(Vector2(tileSize, tileSize))
		moveDirection = inputObject.GetMoveDirectionInput()
		if moveDirection != Vector2.ZERO:
			lastInputDirection = moveDirection
		moveObject.ray.cast_to = moveDirection * (tileSize + 8)		
		lastPosition = moveObject.position
		targetPosition += moveDirection * tileSize		
		return true
	return false

func IsAtTargetPosition(moveObject):
	return moveObject.position == targetPosition
