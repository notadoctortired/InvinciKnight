extends Node3D

## Note - This script requires a node3D with no children except the spawn points from which to be
## selected from

@export_category("Cooldowns")
@export var peasant_cooldown: float
@export var sorcerer_cooldown: float
@export var sorcerer_delay: float

# Enemy nodes
@onready var peasant = "res://AI/Peasant/peasant.tscn"
@onready var sorcerer = "res://AI/Sorcerer/sorcerer.tscn"

# Timers for spawning enemies
@onready var peasant_timer = 0
@onready var sorcerer_timer = sorcerer_delay

# Separate spawn points for sorcerers
@onready var sorcerer_spawn_points = get_parent().get_node("SorcererSpawnPoints")

func _ready():
	pass

func _process(delta: float):
	if peasant_timer <= 0:
		spawn_peasant()
	else:
		peasant_timer -= 1*delta
	
	if sorcerer_timer <= 0:
		spawn_sorcerer()
	else:
		sorcerer_timer -= 1*delta

func spawn_peasant():
	var spawn_location = randi_range(0,get_children().size()-1)
	spawn_location = get_child(spawn_location).global_position
	
	# Loads enemy scene into PackedScene
	var scene = load(peasant)
	# Creates an instance of the unit
	var instance = scene.instantiate()
		
	# Sets the unit's position (adjusting it to be above the ground using the child node "Base")
	# and adds it to the scene tree
	instance.position = spawn_location - (2*instance.get_node("NavRoot").position)
	get_tree().root.get_child(0).add_child(instance)
	
	peasant_timer = peasant_cooldown

func spawn_sorcerer():
	var spawn_location = randi_range(0,sorcerer_spawn_points.get_children().size()-1)
	spawn_location = sorcerer_spawn_points.get_child(spawn_location).global_position
	
	# Loads enemy scene into PackedScene
	var scene = load(sorcerer)
	# Creates an instance of the unit
	var instance = scene.instantiate()
	
	# Sets the unit's position (adjusting it to be above the ground using the child node "Base")
	# and adds it to the scene tree
	instance.position = spawn_location - (2*instance.get_node("NavRoot").position)
	get_tree().root.get_child(0).add_child(instance)

	sorcerer_timer = sorcerer_cooldown
