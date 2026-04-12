extends Area3D

# Parent Node Variables
@onready var arrow = get_parent()
@onready var player = get_tree().root.get_child(0).get_node("Player/PlayerBody")
@onready var damage_mult = player.damage_mult

# SFX Variables
@onready var impact_sfx = arrow.get_node("ImpactSFX")

func _ready():
	print(player)
	body_entered.connect(hit)

func hit(body):
	if body.has_method("damage") and body.get_child(0).name == "EnemyFlag":
		body.damage(arrow.damage*damage_mult)
		
		impact_sfx.pitch_scale = 1 + randf_range(-0.15,0.15)
		impact_sfx.play()
