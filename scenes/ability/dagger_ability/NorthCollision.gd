extends CollisionShape2D


func _on_north_hitbox_area_entered(area):
	queue_free()
