extends CharacterBody3D

@export_category("Values")
@export var speed: float
@export var damage: float
@export var despawn_time: float

# Movement Variables
var target_pos = null

# Parent Node Variables
@onready var root = get_tree().root.get_child(0)
@onready var player = root.get_node("Player/PlayerBody")

# SFX Variables
@onready var movement_sfx = $MovementSFX

func _ready():
	$Timer.timeout.connect(kill_actor)
	$Timer.start(despawn_time)
	
	if is_instance_valid(player):
		target_pos = player.global_position
		look_at(target_pos)
	
	actor_setup.call_deferred()

func actor_setup():
	await get_tree().physics_frame
	
func _physics_process(delta: float):
	if $MeshInstance3D.visible:
		velocity = -global_basis.z*speed*delta
	else:
		velocity = Vector3.ZERO
	
	if velocity != Vector3.ZERO and not movement_sfx.playing:
		movement_sfx.stream.loop = true
		movement_sfx.play()
	
	if not $MeshInstance3D.visible:
		movement_sfx.stop()
	
	move_and_slide()

func kill_actor():
	queue_free()
