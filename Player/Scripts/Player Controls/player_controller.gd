extends CharacterBody3D

@export_category("Player Values")
@export var health: float
@export var speed: float
@export var damage_mult: float

func _ready():
	$SlashArea/Timer.timeout.connect(hide_attacks) # Catch-all function that hides every weapon
	# once it has been triggered

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
	
	if health <= 0:
		kill_actor()

func _input(event: InputEvent):
	if event.is_action_pressed("rotate_right"):
		# 0.7853982 is 45 degrees in radians
		rotate_y(-0.7853982)
	
	if event.is_action_pressed("rotate_left"):
		rotate_y(0.7853982)
		
	if event.is_action_pressed("swing") and not $SlashArea.visible:
		swing_attack()
	
func swing_attack():
	$SlashArea.visible = true
	$SlashArea.monitoring = true 
	
	$SlashArea/Timer.start(0.5)
	
func hide_attacks():
	$SlashArea.visible = false
	$SlashArea.monitoring = false

func kill_actor():
	get_tree().change_scene_to_file("res://Maps/Menus/death.tscn")
