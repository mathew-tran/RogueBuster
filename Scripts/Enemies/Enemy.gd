extends KinematicBody2D

var tileSize = 64.0

onready var ray = $ray
onready var bulletSpawnPosition = $BulletSpawnPosition
onready var movementComponent = $MoveComponent
onready var flinchTimer = $FlinchTimer
onready var sprite = $Sprite

signal EnemyDeath

var result
var behaviours
var index = 0
var canMove = true
var startModulate
var isDead = false
var move_vector = Vector2(1,0)

export(Material) var hitMaterial
export(int) var prizes = 1

var deathTimer
	
func UpdateUI():	
	$UI/ProgressBar.max_value = $Health.maxHealth
	$UI/ProgressBar.value = $Health.health
	$UI/HealthText.text = str($Health.health) + "/" + str($Health.maxHealth)
	
func _ready():
	$Health.connect("UpdateHealthEvent", self, "UpdateUI")
	get_tree().get_nodes_in_group("Player")[0].connect("PlayerDeath", self, "_on_Player_PlayerDeath")
	startModulate = $Sprite.modulate
	$UI/ProgressBar.min_value = 0
	$Health.Setup()
	UpdateUI()
	behaviours = $Behaviours.get_children()
	behaviours[index].Setup()
	movementComponent.Setup(self)
	
	deathTimer = Timer.new()
	deathTimer.wait_time = 1.0
	deathTimer.one_shot = true
	deathTimer.autostart = false
	
	deathTimer.connect("timeout", self, "EnemyKill")
	add_child(deathTimer)

func _process(delta):
	if canMove && !isDead:
		if $FlinchTimer.time_left == 0:
			if behaviours[index].CanRun():
				behaviours[index].Action(delta)
			else:
				#behaviours[index].Setup()
				index += 1
				if index > behaviours.size() - 1:
					index = 0
					
				behaviours[index].Setup()
		
		var result = move_and_collide(Vector2.ZERO, false, true, true)
		if result:
			var projectile = result.collider.is_in_group('Projectile')
			if projectile:
				if !result.collider.canHitPlayer:
					result.collider.Hit($Health, self, $DamageTextSpawn.global_position)
			if result.collider.is_in_group('Player'):
				result.collider.PlayerCollideEnemy(3, $DamageTextSpawn.global_position)			
			if result.collider.is_in_group("Buff"):
				result.collider.GiveCharacter($Health)
				
			result = null

func TakeDamage(damage, flinchAmount):
	if $HurtTimer.time_left == 0:	
		$FlinchTimer.stop()		
		$FlinchTimer.wait_time = flinchAmount	
		$FlinchTimer.start()
		
		$Sprite.material = hitMaterial
		$HurtTimer.start()
		$Health.TakeDamage(damage)

func _on_Health_IsDeadEvent():
	$DeathSound.play()
	var projectileClass = load("res://Scenes/Particles/Enemy Explosion.tscn")
	var projectile = projectileClass.instance()
	projectile.global_position = $Sprite.global_position
	get_parent().add_child(projectile)
	deathTimer.start()
	isDead = true
	#queue_free()
	
func EnemyKill():
	emit_signal("EnemyDeath")


func _on_Health_TakeDamageEvent():
	UpdateUI()

func _on_Player_PlayerDeath():
	canMove = false

func _on_HurtTimer_timeout():
	$Sprite.material = null
	
func Hide():
	canMove = false
	visible = false
	$CollisionShape2D.disabled = true

func Reset():
	canMove = true
	visible = true
	$CollisionShape2D.disabled = false
	
	
