extends CharacterBody3D

@export_category("Values")
@export var speed: float

var move_target_pos = Vector3(0,0,0)

@onready var navigation_agent = $NavRoot/NavigationAgent3D
@onready var root = get_tree().root.get_child(0)
@onready var player = root.get_node("Player/PlayerBody")

func _ready():
	look_at(player.global_position)
	move_target_pos = player.global_position
	
	
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	
	actor_setup.call_deferred()

func actor_setup():
	await get_tree().physics_frame

func set_movement_target(target):
	navigation_agent.set_target_position(target)
	
func _physics_process(delta):
	
	set_movement_target(move_target_pos)

	var current_agent_pos = global_position
	var next_path_pos = navigation_agent.get_next_path_position()
	
	velocity = current_agent_pos.direction_to(next_path_pos) * speed
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	move_and_slide()

func kill_actor():
	queue_free()
