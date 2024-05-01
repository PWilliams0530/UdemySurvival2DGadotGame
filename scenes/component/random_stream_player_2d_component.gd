extends AudioStreamPlayer2D

@export var streams : Array[AudioStream]

func play_random():
	if streams == null || streams.size() == 0:
		return
	
	var random_stream = streams.pick_random()
	stream = random_stream
	play()
