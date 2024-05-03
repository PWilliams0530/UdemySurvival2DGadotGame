extends CanvasLayer

@export var upgrades : Array[MetaUpgrade] = []

@onready var grid_container = $%GridContainer
@onready var back_button = %BackButton

var meta_card_upgrade_scene = preload("res://scenes/UI/meta_upgrade_card.tscn")

func _ready():
	
	back_button.pressed.connect(on_back_pressed)
	
	for child in grid_container.get_children():
		child.queue_free()
	
	for upgrade in upgrades:
		var meta_card_upgrade_instance = meta_card_upgrade_scene.instantiate()
		grid_container.add_child(meta_card_upgrade_instance)
		meta_card_upgrade_instance.set_meta_upgrade(upgrade)

func on_back_pressed():
	ScreenTransition.transition_to_scene("res://scenes/UI/main_menu.tscn")
