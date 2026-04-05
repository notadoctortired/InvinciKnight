extends Area3D

@export_category("Progress Variables")
@export var progress_total: float

@onready var enemies = []

# Player Variables
@onready var root = get_tree().root.get_child(0)
@onready var player = root.get_node("Player/PlayerBody")

func _ready() -> void:
	body_entered.connect(add_enemy)
	
func process(delta: float):
	if enemies.size() > 0:
		var timer = player.get_node("PlayerUI/RoundTimer")
		
		

func add_enemy(body):
	if body.get_child(0).name == "EnemyFlag":
		enemies.append(body)
		print(body.name)
