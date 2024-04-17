extends Node
const SPAWN_RADIUS = 375 #spawn outside of window
@export var basic_enemy_scene: PackedScene

func _ready():
	$Timer.timeout.connect(on_timer_timeout)
	

func on_timer_timeout():
	var player = get_tree().get_first_node_in_group("player") as Node2D #grab player
	if player == null:
		return
	
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU)) # get random direction
	var spawn_position = player.global_position + (random_direction * SPAWN_RADIUS) #go in random direction from player radius pixels
	
	var enemy = basic_enemy_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy) #add to parent (Main)
	enemy.global_position = spawn_position #assign to global position
	
