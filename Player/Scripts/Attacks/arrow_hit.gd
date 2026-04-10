extends Area3D

@onready var arrow = get_parent()
@onready var player = get_tree().root.get_child(0).get_node("Player/PlayerBody")
@onready var damage_mult = player.damage_mult

func _ready():
	print(player)
	body_entered.connect(hit)

func hit(body):
	if body.has_method("damage") and body.get_child(0).name == "EnemyFlag":
		body.damage(arrow.damage*damage_mult)
