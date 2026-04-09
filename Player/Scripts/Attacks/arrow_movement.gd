extends CharacterBody3D

@export_category("Values")
@export var speed: float
@export var damage: float
@export var despawn_time: float

func _ready():
	$Timer.timeout.connect(kill_actor)
	$Timer.start(despawn_time)
	
func _physics_process(delta: float):
	velocity = global_basis.z*speed*delta
	
	move_and_slide()
	
func kill_actor():
	queue_free()
