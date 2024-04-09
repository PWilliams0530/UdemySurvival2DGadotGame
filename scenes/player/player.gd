extends CharacterBody2D

const MAX_SPEED = 200


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	#built in property of CharacterBody2D (a vector2) - F1 Opens Dialog
	velocity = direction * MAX_SPEED
	#moves based on velocity
	move_and_slide()


func get_movement_vector():
	var movement_vector = Vector2.ZERO
	
	# returns 1 or 0 for keyboard, returns fraction for joystick
	# returns 1 if pressed
	# if movement right isnt pressed, and left is - then its -1 movement
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	#y is positive - positive goes first
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement,y_movement)
