extends Area2D
class_name ArrowAbility

@export var SPEED: int = 5
@onready var hitbox_component = $HitboxComponent
@onready var sprite_object = $Visuals/Sprite2D as Sprite2D

var direction_vector = Vector2.RIGHT
var sprite_rotation_degrees = 0

func _physics_process(delta):
	if direction_vector == Vector2(0,0):
		direction_vector = Vector2(1,0)
	var delta_vector = Vector2(delta,0)  # Assuming delta affects x-axis
	sprite_object.rotation = deg_to_rad(sprite_rotation_degrees)
	global_position += (float(SPEED) * direction_vector) + delta_vector
