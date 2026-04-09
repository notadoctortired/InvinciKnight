extends CharacterBody3D

@export_category("Values")
@export var speed: float
@export var damage: float

var target_pos = null

@onready var root = get_tree().root.get_child(0)
@onready var player = root.get_node("Player/PlayerBody")

func _ready():
	$Timer.timeout.connect(kill_actor)
	
	if is_instance_valid(player):
		target_pos = player.global_position
		look_at(target_pos)
	
	actor_setup.call_deferred()

func actor_setup():
	await get_tree().physics_frame
	
func _physics_process(delta: float):
	velocity = -global_basis.z*speed*delta
	
	move_and_slide()

func kill_actor():
	queue_free()
