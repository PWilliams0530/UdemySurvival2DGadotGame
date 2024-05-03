extends CanvasLayer

@export var upgrades : Array[MetaUpgrade] = []

@onready var grid_container = $%GridContainer

var meta_card_upgrade_scene = preload("res://scenes/UI/meta_upgrade_card.tscn")

func _ready():
	for upgrade in upgrades:
		var meta_card_upgrade_instance = meta_card_upgrade_scene.instantiate()
		grid_container.add_child(meta_card_upgrade_instance)
		meta_card_upgrade_instance.set_meta_upgrade(upgrade)
