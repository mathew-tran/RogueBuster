extends Node2D




var vector = Vector2()

func _ready():
	vector.x = randf() * 200.0 + -randf() * 200.0
	vector.y = -100 + randf() * 50.0
	randomize()

func _process(delta):
	position += vector * delta
func SetText(string):
	$Label.text = string
func SetColor(color):
	$Label.add_color_override("font_color", color)

func _on_Timer_timeout():
	queue_free()
