extends CharacterBody3D

@export_category("Player Values")
@export var health: float
@export var speed: float
@export var damage_mult: float

var meshes = null
var crossbow_active = false

func _ready():
	meshes = $Meshes
	$SlashArea/Timer.timeout.connect(hide_attacks) # Catch-all function that hides every weapon
	# once it has been triggered
	$PlayerUI/Healthbar.visible = false

func _physics_process(delta: float) -> void:
	if health <= 0:
		kill_actor()
	
	$PlayerUI/Healthbar.value = health
	
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
	
	if velocity != Vector3.ZERO:
		meshes.rotation.y = atan2(velocity.z,-velocity.x)
	
	move_and_slide()

func _input(event: InputEvent):
	if event.is_action_pressed("attack") and not $SlashArea.visible:
		if not crossbow_active:
			swing_attack()
		elif crossbow_active:
			crossobow_attack()
	if event.is_action_pressed("toggle_attack"):
		crossbow_active = !crossbow_active
		
func damage(dmg: float):
	health -= dmg
	
func swing_attack():
	$SlashArea.visible = true
	$SlashArea.monitoring = true 
	
	$SlashArea/Timer.start(0.5)
	
func crossobow_attack():
	pass
	
func hide_attacks():
	$SlashArea.visible = false
	$SlashArea.monitoring = false

func kill_actor():
	get_tree().change_scene_to_file("res://Maps/Menus/death.tscn")
