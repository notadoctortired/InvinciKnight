extends Area3D

@onready var sorcerer_attack = get_parent()

func _ready() -> void:
	body_entered.connect(hit)

func hit(body):
	if body.has_method("damage") and not body.get_child(0).name == "EnemyFlag":
		body.damage(sorcerer_attack.damage)
	
	if body.get_child(0).name == "EnemyFlag":
		print("ignoring!")
	else:
		sorcerer_attack.kill_actor()
	
	print(body)
