extends Area3D

@export_category("Progress Variables")
@export var progress_total: float
@export var progress_mult: float

@onready var enemies = []

# Player Variables
@onready var root = get_tree().root.get_child(0)
@onready var player = root.get_node("Player/PlayerBody")

func _ready() -> void:
	body_entered.connect(add_enemy)
	body_exited.connect(remove_enemy)
	
func _physics_process(_delta: float):
	if enemies.size() > 0:
		progress_total += progress_mult*enemies.size()
		
	if enemies.size() <= 0 and not progress_total <= 100:
		progress_total -= progress_mult
	
	var progress_bar = player.get_node("PlayerUI/CaptureProgress")
	
	progress_bar.value = progress_total
	
	if progress_total >= 100:
		get_tree().change_scene_to_file("res://Maps/Menus/death.tscn")
	
func add_enemy(body):
	if body.get_child(0).name == "EnemyFlag":
		enemies.append(enemies.size()+1)
		print(enemies.size())
		
func remove_enemy(body):
	if body.get_child(0).name == "EnemyFlag":
		enemies.erase(enemies.size())
		print(enemies.size())
