extends KinematicBody2D

export var speed = 1024
var moveVector = Vector2(1,0)
var canHitPlayer = false
var canHit = false
export var flinchAmount = 0.0

export var damage = 2

func _ready():
	$StartParicle.emitting = true
	if flinchAmount == 0.0:
		flinchAmount = 0.001
	
func Setup():	
	if canHitPlayer:		
		$Sprite.modulate = (Color( 1, 0, 0, 1 ))
	canHit = true
	
func _process(delta):
	position += (moveVector * speed * delta)
	var result = move_and_collide(Vector2.ZERO, false, false, true)
	if result:
		if result.collider.get_class() == "TileMap":
			OnDeath()

func Hit(hitObject, character, textPosition):
	hitObject.TakeDamage(damage)
	var damageTextClass = load("res://Scenes/UI/DamageText.tscn")
	var damageText = damageTextClass.instance()
	if character.flinchTimer.time_left == 0.0:
		character.flinchTimer.stop()
		character.flinchTimer.wait_time = flinchAmount
		character.flinchTimer.start()
		
	damageText.SetText(str(damage))
	damageText.position = textPosition
	
	get_parent().add_child(damageText)
	OnDeath()

func OnDeath():
	var soundClass = load("res://Scenes/Sound/SoundEffect.tscn")
	var sound = soundClass.instance()
	sound.global_position = global_position
	var man = get_tree().get_nodes_in_group("manager")[0]
	man.add_child(sound)
	sound.PlaySound()
	
	var particleClass = load("res://Scenes/Particles/BulletParticle.tscn")
	var particle = particleClass.instance()
	particle.global_position = global_position
	particle.emitting = true
	get_parent().add_child(particle)
	queue_free()
	
func _on_DeathTimer_timeout():
	OnDeath()
