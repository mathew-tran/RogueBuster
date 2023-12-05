extends Node


var health = 3
export var maxHealth = 10

signal TakeDamageEvent
signal IsDeadEvent
signal UpdateHealthEvent

var timer
var waitTime = 0.01
var healthToLose = 0
var healthToGain = 0

func _ready():
	timer = Timer.new()
	timer.wait_time = waitTime
	timer.set_one_shot(true)
	timer.autostart = false
	
	add_child(timer)
	timer.connect("timeout", self, "_health_change")
	
func Setup():	
	health = maxHealth

func Heal(amount):
	healthToGain += amount
	emit_signal("TakeDamageEvent")
	var damageTextClass = load("res://Scenes/UI/DamageText.tscn")
	var damageText = damageTextClass.instance()
	damageText.SetText(str(amount))
	damageText.position = get_parent().get_node("DamageTextSpawn").global_position
	damageText.SetColor(Color.lightgreen)
	add_child(damageText)
	
	timer.start()

func AddHealth(amount):
	maxHealth += amount
	emit_signal("TakeDamageEvent")
	
func TakeDamage(damage):
	healthToLose += damage
	emit_signal("TakeDamageEvent")
	timer.start()
	
func IsAlive():
	return health > 0
	
func _health_change():
	if healthToGain > 0:
		health += 1
		healthToGain -= 1		
		if health >= maxHealth:
			health = maxHealth		
	if healthToLose > 0:
		health -= 1
		healthToLose -= 1
		if health <= 0:
			health = 0
			emit_signal("IsDeadEvent")
	emit_signal("UpdateHealthEvent")
	if healthToGain > 0 || healthToLose > 0:
		timer.start()
