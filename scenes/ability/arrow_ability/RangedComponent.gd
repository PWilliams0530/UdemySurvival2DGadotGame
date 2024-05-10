extends Area2D
class_name RangedComponent

@onready var arrow_ability = $".."

func remove_scene():
	arrow_ability.queue_free()

	
