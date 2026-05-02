extends CharacterBody3D

@export_category("Values")
@export var speed: float
@export var health: float

var move_target_pos = Vector3(0,0,0)

@onready var navigation_agent = $NavRoot/NavigationAgent3D
@onready var scene_root = get_tree().get_current_scene()

var nav_points = null
var point = null

var randomisation = randf_range(-1,1)

func _ready():
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	
	actor_setup.call_deferred()
	
	var koth = scene_root.get_node("KOTH")
	
	if koth != null:
		nav_points = koth.get_node("NavPoints").get_children()
		point = randi_range(0,nav_points.size()-1) # Reduce by one to correct index
		
		move_target_pos = nav_points[point].global_position
		
	speed += randomisation
	
func actor_setup():
	await get_tree().physics_frame
	
func set_movement_target(target):
	navigation_agent.set_target_position(target)

func _physics_process(delta):
	set_movement_target(move_target_pos)
	
	if health <= 0:
		kill_actor()
		return
	
	if NavigationServer3D.map_get_iteration_id(navigation_agent.get_navigation_map()) == 0:
		return
	if navigation_agent.is_navigation_finished():
		return
	
	var current_agent_pos = global_position
	var next_path_pos = navigation_agent.get_next_path_position()
	
	velocity = current_agent_pos.direction_to(next_path_pos) * speed
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	look_at(move_target_pos, Vector3.UP,true)
	
	move_and_slide()

func kill_actor():
	queue_free()

func damage(dmg):
	health -= dmg
