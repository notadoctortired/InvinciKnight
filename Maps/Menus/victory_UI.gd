extends Button

func _ready() -> void:
	button_down.connect(clicked)

func clicked():
	if name == "ExitGame":
		get_tree().quit(0)
