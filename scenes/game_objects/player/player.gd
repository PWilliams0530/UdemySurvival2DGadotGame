extends CharacterBody2D

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent

var number_colliding_bodies = 0
var base_speed = 0




# Called when the node enters the scene tree for the first time.
func _ready():
	base_speed = velocity_component.max_speed
	
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_intererval_timer_timeout)
	health_component.health_changed.connect(on_health_changed)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	update_health_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var movement_vector = get_movement_vector()
	var direction = movement_vector.normalized()
	velocity_component.accelerate_in_direction(direction)
	velocity_component.move(self)
	
	if movement_vector.x != 0 || movement_vector.y != 0:
		animation_player.play("walk")
	else:
		animation_player.play("RESET")
		
	var move_sign = sign(velocity.x)
	if move_sign != 0:
		visuals.scale = Vector2(move_sign,1)


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
	GameEvents.emit_player_damaged()
	update_health_display()

func on_ability_upgrade_added(ability_upgrade : AbilityUpgrade, current_upgrades : Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.Id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed + current_upgrades["player_speed"]["quantity"] * .1)
		
	
