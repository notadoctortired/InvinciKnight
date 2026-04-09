extends Area3D

@onready var sorcerer_attack = get_parent()

func _ready() -> void:
	body_entered.connect(hit)

func hit(body):
	if body.has_method("damage") and not get_child(0).name == "EnemyFlag":
		body.damage(sorcerer_attack.damage)
		
	print(body)
	sorcerer_attack.kill_actor()
