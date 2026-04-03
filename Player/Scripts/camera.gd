extends Camera3D
# Allows user to set target position for camera and where the camera should look.
# These should not be the same, if used for first person camera system keep look clear.
@export_category("Targets")
@export var target_follow: Node3D
@export var target_look: Node3D

@export_category("Smoothing")
@export var follow_speed: float

@onready var target_position = target_follow.global_position

func _ready():
	global_position = target_position
	
func _process(delta: float):
	
	if target_follow != null:
		target_position = target_follow.global_position

		var weight = 1 - exp(-follow_speed*delta)
		global_position = global_position.lerp(target_position,weight)
		
	if target_look != null:
		look_at(target_look.global_position)
