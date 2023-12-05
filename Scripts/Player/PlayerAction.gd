extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
enum WeaponType {
	PRIMARY,
	SECONDARY
}
export(PackedScene) var scene_file
export var time = 3.0
export var actionName = "shoot"
export(String) var description = "empty description"
export(WeaponType) var type = WeaponType.PRIMARY

var timer
signal ActionUpdate(maxValue, currentValue)

func get_type():
	return "PlayerAction"

func Set(action):
	time = action.time
	actionName = action.actionName
	scene_file = action.scene_file
	timer.wait_time = time
	
func _ready():
	timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	timer.autostart = false
	add_child(timer)
	
func _process(delta):
	emit_signal("ActionUpdate", timer.wait_time, timer.time_left)	
	
func GetWaitTime():
	return timer.wait_time

func GetTimeLeft():
	return timer.time_left
	
func CanUse():
	return timer.time_left == 0

func Use(spawnPosition, movementComponent):
	if CanUse():
		var projectile = scene_file.instance()
		projectile.position = spawnPosition
		projectile.moveVector = movementComponent.lastInputDirection
		get_parent().get_parent().add_child(projectile)
		timer.start()
		return true	
	return false
