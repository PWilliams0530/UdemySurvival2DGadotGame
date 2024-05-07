extends CollisionShape2D

func on_body_entered(body):
	queue_free()
	%SouthEast.queue_free()
