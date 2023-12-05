extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var canBeUsed = true

signal UseStairs
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if canBeUsed:
		var result = move_and_collide(Vector2.ZERO, false, true, true)
		if result:
			var isPlayer = result.collider.is_in_group("Player")
			if isPlayer:
				emit_signal("UseStairs")
				Hide()
				$AudioStreamPlayer2D.play()

func Reset():
	canBeUsed = true
	visible = true
	$AnimationPlayer.seek(0)
	$CollisionShape2D2.disabled = false	
	$AnimationPlayer.play("SpawnIn")
	
func Hide():
	canBeUsed = false
	visible = false
	$CollisionShape2D2.disabled = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
