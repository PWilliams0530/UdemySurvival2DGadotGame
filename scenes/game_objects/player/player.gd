extends CharacterBody2D

const MAX_SPEED = 125
const ACCELERATION_SMOOTHING = 25
@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar

var number_colliding_bodies = 0




# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_intererval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	update_health_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	#built in property of CharacterBody2D (a vector2) - F1 Opens Dialog
	var target_velocity = direction * MAX_SPEED
	velocity = velocity.lerp(target_velocity, 1 - exp(-delta * ACCELERATION_SMOOTHING)) # what is lerp?
	#moves based on velocity
	move_and_slide()


func get_movement_vector():
	#var movement_vector = Vector2.ZERO
	
	# returns 1 or 0 for keyboard, returns fraction for joystick
	# returns 1 if pressed
	# if movement right isnt pressed, and left is - then its -1 movement
	var x_movement = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	#y is positive - positive goes first
	var y_movement = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	return Vector2(x_movement,y_movement)
	

func on_body_entered(other_body: Node2D):
	number_colliding_bodies += 1
	check_deal_damage()

func on_body_exited(other_body: Node2D):
	number_colliding_bodies -= 1
	
func check_deal_damage():
	if number_colliding_bodies == 0 || !damage_interval_timer.is_stopped():
		return
	health_component.damage(1)
	damage_interval_timer.start()
	
func update_health_display():
	health_bar.value = health_component.get_health_percent()
	

func on_damage_intererval_timer_timeout():
	check_deal_damage()
	
func on_health_changed():
	update_health_display()
