extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if visible:
		if event.is_action_pressed("ui_accept"):
			get_tree().get_nodes_in_group("manager")[0]._on_Game_Start_Button_pressed()
			$AudioStreamPlayer2D.play()
			visible = false
			
		
	
