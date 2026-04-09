extends Area3D

@onready var player = get_parent()

func _ready():
	body_entered.connect(hit)
	visible = false
	monitoring = false
	
func hit(body):
	var dmg = 10*player.damage_mult
	if visible:
		if body.get_child(0).name == "EnemyFlag": # All enemies have a node3D as their first child
		# that flags them as enemies
			body.damage(dmg)
