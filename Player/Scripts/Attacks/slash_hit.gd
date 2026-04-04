extends Area3D

@onready var player = get_parent()

func _ready():
	body_entered.connect(damage)
	visible = false
	
func damage(body):
	if visible:
		if body.enemy_flag == true:
			print("enemy hit!")
