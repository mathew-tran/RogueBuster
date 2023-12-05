extends Sprite

var flinchTimer

func _ready():
	flinchTimer = get_parent().get_node("FlinchTimer")
	pass # Replace with function body.

func _process(delta):
	if flinchTimer.time_left == 0:
		visible = false
	else:
		visible = true
		rotate(5 * delta)
