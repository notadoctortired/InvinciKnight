extends AudioStreamPlayer

@export_category("Values")
@export var volume: float

func _ready():
	var samples = stream.get_length()*stream.mix_rate
	
	volume_db = volume
	stream.loop_mode = 1
	stream.set_loop_end(samples)
	
	play()
