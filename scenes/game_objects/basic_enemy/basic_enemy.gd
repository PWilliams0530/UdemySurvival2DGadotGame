extends CharacterBody2D

@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent

# Called when the node enters the scene tree for the first time.
#func _ready():
	#$Area2D.area_entered.connect(on_area_entered)
	
func _ready():
	$HurtBoxComponent.hit.connect(on_hit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity_component.accelerate_to_player()
	velocity_component.move(self)
	
	#makes rats go the way they are moving
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(-move_sign,1)

#func on_area_entered(other_area: Area2D):
	#health_component.damage(100)
	
func on_hit():
	$AudioStreamPlayer2D.play()
