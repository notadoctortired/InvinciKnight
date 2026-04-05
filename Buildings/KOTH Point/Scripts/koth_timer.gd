extends StaticBody3D

@export_category("Round Variables")
@export var round_length: float

@onready var timer = $Timer
@onready var root = get_tree().root.get_child(0)
@onready var UI = root.get_node("Player/PlayerBody/PlayerUI")

func _ready():
	timer.timeout.connect(win)
	timer.start(round_length)
	
	var timerUI = UI.get_node("RoundTimer")
	
	timerUI.text = "Time Remaining: " + str(int(round_length))

func _physics_process(delta: float):
	var timerUI = UI.get_node("RoundTimer")
	
	if round_length > 0:
		round_length -= 1*delta
	
	timerUI.text = "Time Remaining: " + str(int(round_length))

func win():
	get_tree().change_scene_to_file("res://Maps/victory.tscn")
