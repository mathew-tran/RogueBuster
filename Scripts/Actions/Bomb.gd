extends "res://Scripts/Actions/Bullet.gd"

export var bulletDamage = 5
export var pieces = 8

func _process(delta):
	moveVector = Vector2.ZERO
	pass
	
func SpawnBullet(direction):
	var bulletClass = load("res://Scenes/Actions/Bullet.tscn")
	var bullet = bulletClass.instance()
	bullet.global_position = global_position
	bullet.canHitPlayer = canHitPlayer
	bullet.damage = bulletDamage
	bullet.Setup()
	bullet.moveVector = direction
	get_parent().add_child(bullet)
	
func OnDeath():
	set_collision_layer(0)
	visible = false	
	var degree = float(360) / float(pieces)
	for piece in range(pieces):
		SpawnBullet(Vector2(1,0).rotated(deg2rad(piece * degree)))
	$ExplosionTimer.start()
	
	pass

func _on_ExplosionTimer_timeout():
	.OnDeath()
	pass # Replace with function body.
