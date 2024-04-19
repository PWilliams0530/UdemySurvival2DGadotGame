extends Node
const SPAWN_RADIUS = 250 #spawn outside of window
@export var basic_enemy_scene: PackedScene
@export var arena_time_manager: Node

@onready var timer = $Timer

var base_spawn_time = 0

func _ready():
	base_spawn_time = timer.wait_time
	timer.timeout.connect(on_timer_timeout)
	arena_time_manager.arena_difficulty_increased.connect(on_arena_difficulty_increased)
	

func get_spawn_position():
	var player = get_tree().get_first_node_in_group("player") as Node2D #grab player
	if player == null:
		return Vector2.ZERO
		
	var spawn_position = Vector2.ZERO # get random direction
	var random_direction = Vector2.RIGHT.rotated(randf_range(0,TAU))
	
	for i in 1000:
		spawn_position = player.global_position + (random_direction * SPAWN_RADIUS) #go in random direction from player radius pixels
	#bitwise operators
		var query_paramaters = PhysicsRayQueryParameters2D.create(player.global_position, spawn_position,1 << 0)
		var result = get_tree().root.world_2d.direct_space_state.intersect_ray(query_paramaters)
		
		if result.is_empty():
		#we are clear
			return spawn_position
		else:
			random_direction = random_direction.rotated(deg_to_rad(90))
			
	return Vector2.ZERO
	
func on_timer_timeout():
	
	timer.start()
	
	var player = get_tree().get_first_node_in_group("player") as Node2D #grab player
	if player == null:
		return
	
	var enemy = basic_enemy_scene.instantiate() as Node2D
	
	var entities_layer = get_tree().get_first_node_in_group("entities_layer")
	entities_layer.add_child(enemy) #add to parent (Main)
	enemy.global_position = get_spawn_position() #assign to global position
	

func on_arena_difficulty_increased(arena_difficulty: int):
	var time_off = (.1/12) * arena_difficulty
	time_off = min(time_off, .7)
	print(time_off)
	timer.wait_time = base_spawn_time - time_off
	
	
