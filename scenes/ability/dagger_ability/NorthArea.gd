extends Area2D

func on_body_entered(body):
	print("north body entered")
	queue_free()
	%North.queue_free()
