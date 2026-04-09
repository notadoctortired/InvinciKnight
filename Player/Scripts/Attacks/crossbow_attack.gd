extends Area3D

@export_category("Values")
# MUST be even
@export var arrows: int
@export var firing_arc: float

@onready var meshes = get_parent()

var firing_point = null
var arrow_number = 0

func _ready():
	visible = false
	
func fire_arrows():
	firing_point = global_position
	arrow_number = 0
	
	for arrow in range(0,arrows):
		arrow_number += 1
		
		var arrow_arc_step = firing_arc / arrows*1.5
		var current_arc = firing_arc - (arrow_arc_step*arrow_number)
		
		var spawn_location = firing_point
		
		var scene = load("res://Player/Attacks/crossbow_arrow.tscn")
		var instance = scene.instantiate()

		instance.global_position = spawn_location
		instance.rotation.y = meshes.rotation.y-deg_to_rad(90)-current_arc
		
		get_tree().root.add_child(instance)
