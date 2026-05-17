extends StaticBody3D

@export var round_length = 125

@onready var timer = $Timer
@onready var root = get_tree().root.get_child(0)
var UI = null

func _ready():
	timer.timeout.connect(win)
	timer.start(round_length)
	
	UI = root.get_node("Player/PlayerBody/PlayerUI")
	
	var timerUI = UI.get_node("RoundTimer")
	
	timerUI.text = "Time Remaining: " + str(int(round_length))

func _physics_process(delta: float):
	UI = root.get_node("Player/PlayerBody/PlayerUI") # Godot web build is killing me
	var timerUI = UI.get_node("RoundTimer")
	
	if round_length > 0:
		round_length -= 1*delta
	
	timerUI.text = "Time Remaining: " + str(int(round_length))

func win():
	get_tree().change_scene_to_file("res://Maps/Menus/victory.tscn")
