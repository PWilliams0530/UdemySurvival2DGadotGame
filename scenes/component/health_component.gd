extends Node
class_name HealthComponent

signal died
@export var max_health = 10
var current_health

func _ready():
	current_health = max_health

func damage(damage_amount: float):
	#takes higher of the current health or 0 to prevent negative health
	current_health = max(current_health - damage_amount, 0)
	if current_health == 0:
		died.emit()
		#removes root node of scene
		owner.queue_free()
