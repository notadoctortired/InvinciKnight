extends CharacterBody3D

@export_category("Values")
@export var speed: float
@export var health: float

@onready var root = get_tree().root.get_child(0)
@onready var player = root.get_node("Player")

func _ready():
	actor_setup.call_deferred()
	
func actor_setup():
	await get_tree().physics_frame
	
func _physics_process(delta):
	if health <= 0:
		kill_actor()
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_instance_valid(player):
		look_at(player.position,Vector3(0,1,0),true)
	
	move_and_slide()

func kill_actor():
	queue_free()
