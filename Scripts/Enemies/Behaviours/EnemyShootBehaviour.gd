extends "res://Scripts/Enemies/Behaviours/EnemyBehaviour.gd"

export var shootTime = 1.0
export var shotAmount = 1
export var afterShootTime = 0.2

export(PackedScene) var scene_file

var currentShotAmount = 0
var isShooting = true

func Setup():
	$ShootTimer.wait_time = shootTime
	$AfterShotTimer.wait_time = afterShootTime
	$ShootTimer.start()
	isShooting = true
	currentShotAmount = 0

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
	if currentShotAmount < shotAmount:
		$ShootTimer.wait_time = $AfterShotTimer.wait_time
		$ShootTimer.start()
	else:
		isShooting = false	
	pass # Replace with function body.