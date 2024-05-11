extends Node

@export var experience_manager : Node
@export var upgrade_screen_scene : PackedScene

var current_upgrades = {}
var upgrade_pool : WeightedTable = WeightedTable.new()

var upgrade_axe = preload("res://resources/upgrades/axe.tres")
var upgrade_axe_damage = preload("res://resources/upgrades/axe_damage.tres")
var upgrade_sword_rate = preload("res://resources/upgrades/sword_rate.tres")
var upgrade_sword_damage = preload("res://resources/upgrades/sword_damage.tres")
var upgrade_player_speed = preload("res://resources/upgrades/player_speed.tres")
var upgrade_anvil = preload("res://resources/upgrades/anvil.tres")
var upgrade_anvil_count = preload("res://resources/upgrades/anvil_amount.tres")
var upgrade_daggers = preload("res://resources/upgrades/daggers.tres")
var upgrade_arrow = preload("res://resources/upgrades/arrow.tres")
var upgrade_arrow_to_explosive = preload("res://resources/upgrades/explosive_arrow.tres")

func _ready():
	
	upgrade_pool.add_item(upgrade_axe,10)
	upgrade_pool.add_item(upgrade_anvil,10)
	upgrade_pool.add_item(upgrade_daggers,10)
	upgrade_pool.add_item(upgrade_arrow,10)
	upgrade_pool.add_item(upgrade_sword_rate,10)
	upgrade_pool.add_item(upgrade_sword_damage,10)
	upgrade_pool.add_item(upgrade_player_speed,5)
	
	
	experience_manager.level_up.connect(on_level_up)
	
	
func apply_upgrade(upgrade: AbilityUpgrade):
	var has_upgrade = current_upgrades.has(upgrade.Id)
	if !has_upgrade:
		current_upgrades[upgrade.Id] = {
			"resource": upgrade,
			"quantity" : 1
		}
	else:
		current_upgrades[upgrade.Id]["quantity"] += 1
		
	
	if upgrade.max_quantity > 0:
		var current_quantity = current_upgrades[upgrade.Id]["quantity"]
		if current_quantity == upgrade.max_quantity:
			upgrade_pool.remove_item(upgrade)
		
	update_upgrade_pool(upgrade)
	GameEvents.emit_ability_upgrade_added(upgrade,current_upgrades)
	
func update_upgrade_pool(chosen_upgrade : AbilityUpgrade):
	if chosen_upgrade.Id == upgrade_axe.Id:
		upgrade_pool.add_item(upgrade_axe_damage,10)
	elif chosen_upgrade.Id == upgrade_anvil.Id:
		upgrade_pool.add_item(upgrade_anvil_count,5)
	elif chosen_upgrade.Id == upgrade_arrow.Id:
		upgrade_pool.add_item(upgrade_arrow_to_explosive,10)
	

func pick_upgrades():
	var chosen_upgrades : Array[AbilityUpgrade] = []
	for i in 2:
		if upgrade_pool.items.size() == chosen_upgrades.size():
			break;
		var chosen_upgrade = upgrade_pool.pick_item(chosen_upgrades)
		chosen_upgrades.append(chosen_upgrade)
	
	return chosen_upgrades
	
	
func on_upgrade_selected(upgrade: AbilityUpgrade):
	apply_upgrade(upgrade)
	
	
func on_level_up(current_level : int):
	var upgrade_screen_instance = upgrade_screen_scene.instantiate()
	add_child(upgrade_screen_instance)
	var chosen_upgrades = pick_upgrades()
	upgrade_screen_instance.set_ability_upgrades(chosen_upgrades as Array[AbilityUpgrade])
	upgrade_screen_instance.upgrade_selected.connect(on_upgrade_selected)
		
