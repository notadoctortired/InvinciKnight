extends Area3D

@onready var arrow = get_parent()
@onready var player = get_tree().root.get_child(0).get_node("Player/PlayerBody")

func _ready():
	print(player)
	body_entered.connect(hit)

func hit(body):
	if body.has_method("damage") and body.get_child(0).name == "EnemyFlag":
		body.damage(arrow.damage)
	
	if body.has_method("hit") or body.name == "PlayerBody":
		print("ignoring!")
	else:
		arrow.kill_actor()
