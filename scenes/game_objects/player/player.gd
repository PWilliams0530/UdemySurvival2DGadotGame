extends CharacterBody2D

@export var arena_time_manager : Node

@onready var damage_interval_timer = $DamageIntervalTimer
@onready var health_component = $HealthComponent
@onready var health_bar = $HealthBar
@onready var abilities = $Abilities
@onready var animation_player = $AnimationPlayer
@onready var visuals = $Visuals
@onready var velocity_component = $VelocityComponent

var number_colliding_bodies = 0
var base_speed = 0
var most_recent_movement = Vector2(1,0)




# Called when the node enters the scene tree for the first time.
func _ready():
	base_speed = velocity_component.max_speed
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	$CollisionArea2D.body_entered.connect(on_body_entered)
	$CollisionArea2D.body_exited.connect(on_body_exited)
	damage_interval_timer.timeout.connect(on_damage_intererval_timer_timeout)
	health_component.health_decreased.connect(on_health_decreased)
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
	
	var captured_movement = Vector2(x_movement,y_movement)
	if captured_movement != Vector2(0,0):
		most_recent_movement = captured_movement
	
	return captured_movement
	
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
	
func on_health_decreased():
	GameEvents.emit_player_damaged()
	$HitRandomStreamPlayer.play_random()
	
func on_health_changed():
	update_health_display()

func on_ability_upgrade_added(ability_upgrade : AbilityUpgrade, current_upgrades : Dictionary):
	if ability_upgrade is Ability:
		var ability = ability_upgrade as Ability
		abilities.add_child(ability.ability_controller_scene.instantiate())
	elif ability_upgrade.Id == "player_speed":
		velocity_component.max_speed = base_speed + (base_speed * (current_upgrades["player_speed"]["quantity"] * .1))
		
func on_arena_difficulty_increased(difficulty: int):
	var health_regeneration_quantity = MetaProgression.get_upgrade_count("health_regeneration")
	if health_regeneration_quantity > 0:
		var is_thirty_second_interval = (difficulty % 6) == 0
		if is_thirty_second_interval:
			health_component.heal(health_regeneration_quantity)
