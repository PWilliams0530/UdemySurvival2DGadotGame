extends Area2D
class_name HitboxComponent

var damage = 0


func _on_arrow_ability_area_entered(area):
	queue_free()
