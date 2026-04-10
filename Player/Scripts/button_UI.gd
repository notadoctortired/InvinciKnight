extends Button

func _ready() -> void:
	button_down.connect(clicked)

func clicked():
	if name == "StartGame":
		get_tree().change_scene_to_file("res://Maps/Main Level/level.tscn")
	elif name == "Settings":
		pass
	elif name == "ExitGame":
		get_tree().quit(0)
