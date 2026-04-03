extends CharacterBody3D

@export_category("Player Values")
@export var health: float
@export var speed: float

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

func _input(event: InputEvent):
	if event.is_action_pressed("rotate_right"):
		# 0.7853982 is 45 degrees in radians
		rotate_y(0.7853982)
	
	if event.is_action_pressed("rotate_left"):
		rotate_y(-0.7853982)

func damage(damage_amount: float):
	health -= damage_amount
