extends CharacterBody3D

@export_category("Values")
@export var speed: float
@export var health: float
@export var attack_cooldown: float
@export var minimum_distance_to_player: float

var move_target_pos = Vector3(0,0,0)

@onready var navigation_agent = $NavRoot/NavigationAgent3D
@onready var scene_root = get_tree().root.get_child(0)
@onready var player = scene_root.get_node("Player/PlayerBody")

var point = null
var nav_points = null

func _ready():
	attack_cooldown += randf_range(-0.2,0.2)
	
	$AttackTimer.timeout.connect(spawn_attack)
	$AttackTimer.start(attack_cooldown)
	
	navigation_agent.path_desired_distance = 0.5
	navigation_agent.target_desired_distance = 0.5
	
	actor_setup.call_deferred()
	
	$SpawnSFX.play()
	
	var koth = scene_root.get_node("KOTH")
	
	if koth != null:
		nav_points = player.get_node("NavPointsSorcerer").get_children()
		point = randi_range(0,nav_points.size()-1) # Reduce by one to correct index
	
func actor_setup():
	await get_tree().physics_frame

func set_movement_target(target):
	navigation_agent.set_target_position(target)
	
func _physics_process(delta):
	if is_instance_valid(player):
		move_target_pos = nav_points[point].global_position
	
		set_movement_target(move_target_pos)
		
		if health <= 0:
			kill_actor()
			return

		var current_agent_pos = global_position
		var next_path_pos = navigation_agent.get_next_path_position()
		
		velocity = current_agent_pos.direction_to(next_path_pos) * speed
		
		if not is_on_floor():
			velocity += get_gravity() * delta
		if is_instance_valid(player):
			look_at(player.global_position)
		
		move_and_slide()

func kill_actor():
	queue_free()
	
func spawn_attack():
	if is_instance_valid(player):
		var distance = global_position.distance_to(player.position)
		
		if distance >= minimum_distance_to_player:
			var spawn_location = $AttackSpawn.global_position
			
			var scene = load("res://AI/Sorcerer/sorcerer_attack.tscn")
			var instance = scene.instantiate()
			
			instance.position = spawn_location
			get_tree().root.add_child(instance)
	
func damage(dmg):
	health -= dmg
