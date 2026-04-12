extends Area3D

@onready var sorcerer_attack = get_parent()
@onready var impact_sfx = sorcerer_attack.get_node("ImpactSFX")
@onready var impact_vfx = sorcerer_attack.get_node("ImpactVFX")

func _ready() -> void:
	body_entered.connect(hit)
	$Timer.timeout.connect(sorcerer_attack.kill_actor)

func hit(body):
	if body.has_method("damage") and not body.get_child(0).name == "EnemyFlag" and monitoring:
		body.damage(sorcerer_attack.damage)
	
	if body.get_child(0).name == "EnemyFlag":
		print("ignoring!")
	else:
		$CollisionShape3D.disabled = true
		sorcerer_attack.get_node("MeshInstance3D").visible = false
		
		impact_sfx.pitch_scale = 1 + randf_range(-0.15,0.15)
		impact_sfx.play()
		impact_vfx.emitting = true
		
		$Timer.start(1.5)
