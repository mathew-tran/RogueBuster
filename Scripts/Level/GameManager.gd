extends Node2D

signal SpawnEnemy

var levels = [	
	"res://Scenes/Levels/Level1.tscn",
	"res://Scenes/Levels/Level2.tscn",
	"res://Scenes/Levels/Level3.tscn",
	#"res://Scenes/Enemies/Characters/EnemyBase.tscn",	
	#"res://Scenes/Enemies/Characters/EnemyEasy.tscn",
	#"res://Scenes/Enemies/Characters/EnemyMedium.tscn",
	#"res://Scenes/Enemies/Characters/EnemySpinner.tscn",
	#"res://Scenes/Enemies/Characters/EnemySniper.tscn",
	#"res://Scenes/Enemies/Characters/EnemyDodger.tscn",
	#"res://Scenes/Enemies/Characters/EnemyBomber.tscn"
]

var healItems = [
	"res://Scenes/PlayerItems/Recoveries/Chicken.tscn",
	"res://Scenes/PlayerItems/Recoveries/Riceball.tscn",
	"res://Scenes/PlayerItems/Recoveries/MysterySoup.tscn",
	"res://Scenes/PlayerItems/Recoveries/MysterySoup.tscn",
	"res://Scenes/PlayerItems/Recoveries/MysterySoup.tscn",
	"res://Scenes/PlayerItems/Recoveries/MysterySoup.tscn",
	"res://Scenes/PlayerItems/Recoveries/LeftoverScraps.tscn",	
	"res://Scenes/PlayerItems/Recoveries/Gummy Candy.tscn",
	"res://Scenes/PlayerItems/Recoveries/Super Meal.tscn",
	"res://Scenes/PlayerItems/Recoveries/Cheese Burger.tscn",
	"res://Scenes/PlayerItems/Recoveries/Cheese Burger.tscn",
	"res://Scenes/PlayerItems/Recoveries/Fries.tscn",
	"res://Scenes/PlayerItems/Recoveries/Fries.tscn",
	"res://Scenes/PlayerItems/Recoveries/Fries.tscn"	
]

var permUpgradesItems = [
	"res://Scenes/PlayerItems/IncreaseHealth/Premium Meat.tscn",
	"res://Scenes/PlayerItems/IncreaseHealth/Kale.tscn",
	"res://Scenes/PlayerItems/IncreaseHealth/Kale.tscn",
	"res://Scenes/PlayerItems/IncreaseHealth/Kale.tscn",
	"res://Scenes/PlayerItems/IncreaseHealth/Kale.tscn",
	"res://Scenes/PlayerItems/Stat Buffs/Chunky Soup.tscn",
	"res://Scenes/PlayerItems/Stat Buffs/Detox Fruit Shake.tscn",
]
var weaponItems = [

	"res://Scenes/PlayerAction/Secondaries/Bomb.tscn",
	"res://Scenes/PlayerAction/Secondaries/SlowShot.tscn",
	"res://Scenes/PlayerAction/Secondaries/Heal.tscn",
	"res://Scenes/PlayerAction/Secondaries/StunBullet.tscn",
	"res://Scenes/PlayerAction/Primaries/WeakShot.tscn",
	"res://Scenes/PlayerAction/Primaries/RegularShot.tscn",
	"res://Scenes/PlayerAction/Primaries/FastShot.tscn",

]

var nextLevelTimer
var uiTimer 
var player
var index = 0
var itemsToGive = 0
var spawnPoints
var isInMenu = false

# Called when the node enters the scene tree for the first time.
func _ready():
	nextLevelTimer = Timer.new()
	nextLevelTimer.wait_time = 2.0
	nextLevelTimer.autostart = false
	nextLevelTimer.one_shot = true
	nextLevelTimer.connect("timeout", self, "SpawnLevel")
	add_child(nextLevelTimer)

	uiTimer = Timer.new()
	uiTimer.wait_time = .5
	uiTimer.autostart = false
	uiTimer.one_shot = true
	uiTimer.connect("timeout", self, "SpawnItems")
	add_child(uiTimer)
	
	player = get_tree().get_nodes_in_group("Player")[0]
	spawnPoints = get_tree().get_nodes_in_group("Spawn")	
	SpawnLevel()

	$PlayerUI/LevelText.text = "Floor " + str(index)
	pass # Replace with function body.

func SpawnLevel():	
	var levelClass = load(levels[index])
	var level = levelClass.instance()
	level.global_position = Vector2(0,0)
	get_node("LevelObject").add_child(level)
	level.Set(self)
	$SpawnPoint.PlaySpawn()
	index += 1
	
func RandomItem(itemList):
	return itemList[randi() % itemList.size()]
	
func GetItemFromPool():
	if player.health.health == player.health.maxHealth:
		var choice = randi() % 2
		if choice == 1:
			return RandomItem(permUpgradesItems)
		else:
			return RandomItem(weaponItems)
	else:
		var choice = randi() % 5
		if choice == 1:
			return RandomItem(weaponItems)
		elif choice == 2:
			return RandomItem(permUpgradesItems)
		else:
			return RandomItem(healItems)

func SpawnItems():
	itemsToGive -= 1
	
	var itemUIClass = load("res://Scenes/UI/ItemUI.tscn")
	var itemUI = itemUIClass.instance()
	get_parent().add_child(itemUI)
	itemUI.SetItem(GetItemFromPool(), itemsToGive)
	#itemUI.SetItem(items[(items.size() - 1)], itemsToGive)
	itemUI.connect("CompleteItemDialog", self, "OnCompleteUI")	

func OnCompleteUI():
	if player.health.IsAlive():
		print(itemsToGive)
		if itemsToGive > 0:		
			SpawnItems()
		else:			
			isInMenu = false

func EnableRestartButton():
	$RestartButton.visible = true

func _on_Player_PlayerDeath():
	$PlayerUI/GameText.text = "You Lose"
	isInMenu = false
	EnableRestartButton()

func GameOver(pos):	
	
	if index >= len(levels):
		EnableRestartButton()
		$PlayerUI/GameText.text = "You Win"	

func _on_Player_ZInput():
	$PlayerUI/ZAction/ZAnimationPlayer.seek(0.0, true)
	$PlayerUI/ZAction/ZAnimationPlayer.stop(true)
	$PlayerUI/ZAction/ZAnimationPlayer.play("FirePrimary")

func _on_Player_XInput():
	$PlayerUI/XAction/XAnimationPlayer.seek(0.0, true)
	$PlayerUI/XAction/XAnimationPlayer.stop(true)
	$PlayerUI/XAction/XAnimationPlayer.play("SpecialAction")


func _on_Game_Start_Button_pressed():
	$GameStartButton.visible = false
	pass # Replace with function body.


func _on_Stair_UseStairs():
	$PlayerUI/FadeIn/FadeInAnimationPlayer.play("FadeOut")	
	pass # Replace with function body.


func _on_Chest_UseChest():
	uiTimer.start()
	isInMenu = true


func _on_FadeInAnimationPlayer_animation_finished(anim_name):
	pass # Replace with function body.


func _on_FadeInAnimationPlayer_animation_started(anim_name):
	SpawnLevel()
	$PlayerUI/LevelText.text = "Floor " + str(index + 1)	
	pass # Replace with function body.
