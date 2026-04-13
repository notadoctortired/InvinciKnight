extends AudioStreamPlayer

@export_category("Values")
@export var volume: float

var playback = 0
@onready var player = get_tree().root.get_child(0).get_node("Player/PlayerBody")
@onready var sorcerer_track = get_tree().root.get_child(0).get_node("LevelMusicSorcerer")

func _ready():
	print(name)
	var samples = stream.get_length()*stream.mix_rate
	
	volume_db = volume
	stream.loop_mode = 1
	stream.set_loop_end(samples)
	
	if name == "LevelMusic":
		play()

func _process(delta: float):
	if playing and name == "LevelMusic":
		playback = get_playback_position()
	elif sorcerer_track.playing:
		playback = sorcerer_track.get_playback_position()
	
	if player.health < 100 and playing and name == "LevelMusic":
		stop()
		sorcerer_track.play(playback)
		
		var samples = stream.get_length()*stream.mix_rate
		
		stream.loop_mode = 1
		stream.set_loop_end(samples)
