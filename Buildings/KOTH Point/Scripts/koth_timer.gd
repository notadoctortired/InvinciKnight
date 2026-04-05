extends StaticBody3D

@export_category("Round Variables")
@export var round_length: float

@onready var timer = $Timer

func _ready():
	timer.timeout.connect(win)
	timer.start(round_length)
	
func win():
	print("You win!")
