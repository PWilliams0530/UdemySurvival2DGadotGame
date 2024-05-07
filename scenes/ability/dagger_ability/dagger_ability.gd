extends Node2D

@onready var hitbox_component = $HitboxComponent


func _on_hitbox_component_2_body_entered(body):
	print("hit")
