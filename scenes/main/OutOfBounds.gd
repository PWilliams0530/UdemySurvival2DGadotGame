extends Area2D


func _on_timer_timeout():
	var area2d = get_node("OutOfBounds")  # Replace "Area2D_Name" with your actual node name
	var child_nodes = area2d.get_children()


func _on_body_entered(body):
	pass
