extends "res://Scripts/Enemies/Behaviours/EnemyBehaviour.gd"

export var shootTime = 1.0
export var shotAmount = 1
export var afterShootTime = 0.2
export var spinAmount = 10

export(PackedScene) var scene_file

var currentShotAmount = 0
var isShooting = true
var initialRotation

func Setup():
	$ShootTimer.wait_time = shootTime
	$AfterShotTimer.wait_time = afterShootTime
	$ShootTimer.start()
	isShooting = true
	currentShotAmount = 0
	initialRotation = enemy.movementComponent.lastInputDirection

func CanRun():
	return isShooting

func _on_ShootTimer_timeout():	
	var projectile = scene_file.instance()
	projectile.canHitPlayer = true
	projectile.Setup()
	projectile.position = enemy.bulletSpawnPosition.global_position
	projectile.moveVector = moveComponent.lastInputDirection
	get_parent().add_child(projectile)
	$AfterShotTimer.start()
	pass # Replace with function body.


func _on_AfterShotTimer_timeout():
	currentShotAmount += 1
	
	enemy.movementComponent.lastInputDirection = enemy.movementComponent.lastInputDirection.rotated(deg2rad(spinAmount))
	if currentShotAmount < shotAmount:
		$ShootTimer.wait_time = $AfterShotTimer.wait_time
		$ShootTimer.start()
	else:
		isShooting = false	
		enemy.movementComponent.lastInputDirection = initialRotation
	pass # Replace with function body.
