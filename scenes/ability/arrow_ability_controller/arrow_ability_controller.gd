extends Node

const BASE_RANGE = 100
const BASE_DAMAGE = 50
var speed = 400

@export var arrow_ability_scene : PackedScene
@onready var arrow_ability : ArrowAbility

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func on_timer_timeout():
	
	if arrow_ability != null:
		arrow_ability.queue_free()
		
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var direction = player.most_recent_movement
	arrow_ability = arrow_ability_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(arrow_ability)
	arrow_ability.global_position = player.global_position
	arrow_ability.direction_vector = direction
	arrow_ability.sprite_rotation_degrees = get_sprite_direction(direction)
	arrow_ability.hitbox_component.damage = BASE_DAMAGE
	
	
func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	pass
	
func get_sprite_direction(vector):
	if vector == Vector2(1,0): #Right
		return 0
	elif vector == Vector2(-1,0): #Left
		return 180
	elif vector == Vector2(0,1): #Down
		return 90
	elif vector == Vector2(0,-1): #UP
		return -90
	elif  vector == Vector2(1,-1): #Up + Right
		return -45
	elif vector == Vector2(1,1): # Down + Right
		return 45
	elif vector == Vector2(-1,1): # Down + Left
		return 135
	elif vector == Vector2(-1,-1): #Up + Left
		return -135
	else:
		return 0
		
func on_arrow_hit():
	arrow_ability.queue_free()


