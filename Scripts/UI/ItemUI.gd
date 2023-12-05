extends Control

signal CompleteItemDialog

export(String) var item
var gameManager


func _ready():
	$AnimationPlayer.current_animation = "SpawnIn"
	$AnimationPlayer.play()
	gameManager = get_tree().get_nodes_in_group("manager")[0]

func _process(delta):
	if !gameManager.isInMenu:
		queue_free()
		
func SetItem(newItem, amountLeft):
	item = newItem
	
	var itemClass = load(item)
	var itemObject = itemClass.instance()
	
	if itemObject.get_type() == "PlayerAction":		
		$group/ItemText.text = itemObject.actionName
	elif itemObject.get_type() == "PlayerItem":
		$group/ItemText.text = itemObject.itemName
	$group/DescriptionText.text = itemObject.description
	$group/ItemsLeft.text = str(amountLeft) + " more item(s)"
	
	
func _input(event):
	if event.is_action_pressed("ui_accept"):
		ReceiveItem()
	elif event.is_action_pressed("ui_cancel"):
		DeclineItem()
		
func ReceiveItem():
	var player = get_tree().get_nodes_in_group("Player")[0]
	player.GetItem(item)
	$AcceptSound.play()
	
func DeclineItem():	
	$DeclineSound.play()

func _on_AnimationPlayer_animation_started(anim_name):
	visible = true


func _on_Sound_finished():
	emit_signal("CompleteItemDialog")
	queue_free()


func _on_DeclineSound_finished():
	emit_signal("CompleteItemDialog")
	queue_free()

