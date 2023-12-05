extends "res://Scripts/Enemies/Behaviours/EnemyBehaviour.gd"

export var restTime = 1.0
var isResting = true

func Setup():
	$RestTimer.wait_time = restTime
	$RestTimer.start()
	isResting = true

func CanRun():
	return isResting

func _on_RestTimer_timeout():
	isResting = false	
