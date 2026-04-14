extends Area3D

var progress_total = 170
var progress_mult = 0.01

var current_progress = 0

@onready var enemies = []

# Player Variables
@onready var root = get_tree().root.get_child(0)
@onready var player = root.get_node("Player/PlayerBody")

@onready var progress_bar = player.get_node("PlayerUI/CaptureProgress")

func _ready() -> void:
	body_entered.connect(add_enemy)
	body_exited.connect(remove_enemy)
	
	progress_bar.max_value = progress_total
	
func _physics_process(delta: float):
	print(progress_bar)
	progress_bar = player.get_node("PlayerUI/CaptureProgress")
	
	if enemies.size() > 0:
		current_progress += progress_mult*enemies.size()
		
	if enemies.size() <= 0 and not current_progress <= 0:
		current_progress -= progress_mult
	
	progress_bar.value = current_progress
	
	if current_progress >= progress_total:
		get_tree().change_scene_to_file("res://Maps/Menus/death.tscn")
	
func add_enemy(body):
	if body.get_child(0).name == "EnemyFlag":
		enemies.append(enemies.size()+1)
		
func remove_enemy(body):
	if body.get_child(0).name == "EnemyFlag":
		enemies.erase(enemies.size())
