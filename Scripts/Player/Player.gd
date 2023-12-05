extends KinematicBody2D

const WeaponType = preload("res://Scripts/Player/PlayerAction.gd").WeaponType

signal ZInput
signal XInput
signal CInput
signal VInput
signal ZInputUpdate(maxValue, currentValue)
signal XInputUpdate(maxValue, currentValue)
signal CInputUpdate(maxValue, currentValue)
signal VInputUpdate(maxValue, currentValue)
signal HealthUpdate(maxValue, currentValue)
signal PlayerDeath

export(Material) var hitMaterial

onready var ray = $RayCast2D
onready var experienceBar = $Exp
onready var health = $Health
onready var movement = $Movement
onready var flinchTimer = $FlinchTimer

var gameManager

func HealthUpdates():	
	emit_signal("HealthUpdate", health.maxHealth, health.health)

func _ready():
	gameManager = get_tree().get_nodes_in_group("manager")[0]
	health.Setup()
	$Movement.Setup(self)
	HealthUpdates()

func SetPosition(pos):
	global_position = pos
	$Movement.Setup(self)
	
func InputUpdates():	
	emit_signal("ZInputUpdate", $ZAction.GetWaitTime(), $ZAction.GetTimeLeft(), $ZAction.actionName)	
	emit_signal("XInputUpdate", $XAction.GetWaitTime(), $XAction.GetTimeLeft(), $XAction.actionName)	
	
func CanDoInput():
	return $Health.IsAlive() && $FlinchTimer.time_left == 0 && !gameManager.isInMenu
	
func _process(delta):
	
	if CanDoInput():
		InputUpdates()
		$Movement.Update(self, self, delta)
	else:		
		if $FlinchTimer.time_left == 0.0:
			$FlinchTimer.wait_time = 0.1
			$FlinchTimer.start()
	var result = move_and_collide(Vector2.ZERO, false, true, true)
	if result:
		var buff = result.collider.is_in_group("Buff")
		if buff:
			result.collider.GiveCharacter(health)
			HealthUpdates()
			
		var projectile = result.collider.is_in_group('Projectile')
		if projectile && !buff:
			if result.collider.canHitPlayer:
				result.collider.Hit($Health, self, $DamageTextSpawn.global_position)
					
		result = null

func GetMoveDirectionInput():
	if CanDoInput():
		var left = Input.is_action_pressed("ui_left")
		var right = Input.is_action_pressed("ui_right")
		var up = Input.is_action_pressed("ui_up")
		var down = Input.is_action_pressed("ui_down")
		
		var direction = Vector2()
		
		direction.x = -int(left) + int(right)
		direction.y = -int(up) + int(down)
		
		if direction.x != 0 && direction.y != 0:
			direction = Vector2.ZERO
			
		#if direction != Vector2.ZERO:			
		#	ray.cast_to = direction * ($Movement.tileSize + 8)
		#	$Movement.lastInputDirection = direction	
	
		return direction
	return Vector2.ZERO

func _input(event):
	if CanDoInput():
		if $Movement.IsAtTargetPosition(self) || true:
			if event.is_action("ZAction"):
				if $ZAction.Use($ActionSpawnPoint.global_position, $Movement):
					emit_signal("ZInput")
			if event.is_action_pressed("XAction"):
				if $XAction.Use($ActionSpawnPoint.global_position, $Movement):
					emit_signal("XInput")
	if event.is_action("Restart"):
		get_tree().get_nodes_in_group("RestartButton")[0]._on_RestartButton_pressed()
			
	
func TakeDamage(projectileObject, flinchTime):
	if $HurtTimer.time_left == 0:
		$Sprite.material = hitMaterial
		projectileObject.Hit(health, flinchTime)
		$HurtTimer.start()
		#get_parent().add_child(damageText)
		HealthUpdates()

func SpawnBullet(res):
	var projectileClass = load(res)
	var projectile = projectileClass.instance()
	projectile.position = $ActionSpawnPoint.global_position
	projectile.move_vector = $Movement.last_input_direction
	get_parent().add_child(projectile)
	
func GetItem(res):
	var itemClass = load(res)
	var itemObject = itemClass.instance()
	get_parent().add_child(itemObject)
	if itemObject.get_type() == "PlayerAction":		
		if itemObject.type == WeaponType.PRIMARY:
			$ZAction.Set(itemObject)
			pass
		if itemObject.type == WeaponType.SECONDARY:
			$XAction.Set(itemObject)
			pass
		InputUpdates()
	elif itemObject.get_type() == "PlayerItem":
		itemObject.Use()
		
	itemObject.queue_free()
	
func PlayerCollideEnemy(damage, textPosition):
	pass

func _on_Health_IsDeadEvent():
	$DeathParticle.visible = true
	emit_signal("PlayerDeath")
	pass # Replace with function body.


func _on_HurtTimer_timeout():
	$Sprite.material = null
	pass # Replace with function body.


func _on_Health_UpdateHealthEvent():
	HealthUpdates()
	pass # Replace with function body.
