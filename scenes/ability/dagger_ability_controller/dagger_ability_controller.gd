extends Node

const BASE_RANGE = 100
const BASE_DAMAGE = 8

@export var dagger_ability_scene : PackedScene

var dagger_count = 5

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	GameEvents.ability_upgrade_added.connect(on_ability_upgrade_added)
	
func on_timer_timeout():
	
	var player = get_tree().get_first_node_in_group("player") as Node2D
	if player == null:
		return
	
	var dagger_ability = dagger_ability_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(dagger_ability)
	dagger_ability.global_position = player.global_position
	dagger_ability.hitbox_component.damage = BASE_DAMAGE
	
	

func on_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	pass
		

