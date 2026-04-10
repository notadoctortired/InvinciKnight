extends AudioStreamPlayer

@export_category("Values")
@export var volume: float

const SORCERER_TRACK = preload("res://Maps/Main Level/Resources/SFX_battle_theme_sorcerers.wav")

var playback = 0
@onready var player = get_tree().root.get_child(0).get_node("Player/PlayerBody")

func _ready():
	var samples = stream.get_length()*stream.mix_rate
	
	volume_db = volume
	stream.loop_mode = 1
	stream.set_loop_end(samples)
	
	play()
	

func _process(delta: float):
	if playing:
		playback = get_playback_position()
	
	if player.health < 100 and stream != SORCERER_TRACK:
		stream = SORCERER_TRACK
		play(playback)
		
		var samples = stream.get_length()*stream.mix_rate
		
		stream.loop_mode = 1
		stream.set_loop_end(samples)
