extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var gameManager
var startEnemyTimer
var player
var isLastLevel
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	pass # Replace with function body.

func Set(gameManagerObject):
	player.SetPosition($SpawnPoint.position)
	print(player.global_position)
	$SpawnPoint.visible = false

	gameManager = gameManagerObject	
	if gameManager.index >= len(gameManager.levels) - 1:
		isLastLevel = true
	
	if $Enemy:
		$Enemy.Hide()
		$Stair.Hide()
		$Enemy.connect("EnemyDeath", self, "RunLevelComplete")
		startEnemyTimer = Timer.new()
		startEnemyTimer.wait_time = 2.5
		startEnemyTimer.autostart = false
		startEnemyTimer.one_shot = true
		startEnemyTimer.connect("timeout", self, "StartEnemy")
		add_child(startEnemyTimer)
		startEnemyTimer.start()
	
	$Stair.connect("UseStairs", self, "UseStair")
	#$Enemy.Hide()
	if $Chest:
		$Chest.Hide()
		$Chest.connect("UseChest", self, "UseChest")
	

func RunLevelComplete():
	print("hit")
	if !isLastLevel:
		$Stair.Reset()
		$Chest.Reset()		
	else:
		gameManager.GameOver(Vector2(0,0))
	$Enemy.queue_free()

func StartEnemy():
	$Enemy.Reset()
	
func UseStair():
	gameManager._on_Stair_UseStairs()
	queue_free()
	
func UseChest():
	gameManager._on_Chest_UseChest()
