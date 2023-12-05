extends "res://Scripts/Enemies/Behaviours/EnemyBehaviour.gd"

var hasTeleported = false
var spawnPoints
var targetPoint
var initialScale

var isShrinking = false
var isGrowing = false
func _ready():
	spawnPoints = get_tree().get_nodes_in_group("Spawn")
	
func Setup():
	hasTeleported = false
	moveComponent.lastPosition = enemy.global_position
	moveComponent.targetPosition = enemy.global_position
	moveComponent.moveDirection = Vector2.ZERO
	initialScale = enemy.sprite.scale
	targetPoint = spawnPoints[randi() % spawnPoints.size()].global_position.snapped(Vector2(64, 64))
	isShrinking = true
	isGrowing = false

func CanRun():
	return !hasTeleported

# Run this in process of the enemy	
func Action(delta):		
	if isShrinking:
		enemy.sprite.scale = enemy.sprite.scale - Vector2(delta, delta) * 15
		if enemy.sprite.scale <= Vector2(0,0):
			enemy.global_position = targetPoint
			isShrinking = false
			isGrowing = true
	else:
		if isGrowing:
			enemy.sprite.scale = (enemy.sprite.scale + Vector2(delta, delta) * 5)
			if enemy.sprite.scale >= initialScale:
				hasTeleported = true
				enemy.sprite.scale = initialScale


