extends "res://Scripts/Actions/Bullet.gd"

func _process(delta):
	moveVector = Vector2.ZERO
	pass
	
func GiveCharacter(healthObject):
	healthObject.Heal(damage)
	$Sprite.visible = false
	$CPUParticles2D.emitting = true
	$CollisionShape2D.disabled = true
	$Timer.start()

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
