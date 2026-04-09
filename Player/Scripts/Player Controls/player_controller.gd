extends CharacterBody3D

@export_category("Player Values")
@export var health: float
@export var speed: float

@export_category("Attack Values")
@export var damage_mult: float
@export var slash_cooldown: float
@export var crossbow_cooldown: float

# Global variables to be assigned in _ready that use $
var crossbow = null
var slash = null
var attack_timer = null
var healthbar = null

var meshes = null
var crossbow_active = false

func _ready():
	crossbow = $Meshes/Crossbow
	slash = $SlashArea
	healthbar = $PlayerUI/Healthbar
	attack_timer = $Timer
	
	meshes = $Meshes
	
	attack_timer.timeout.connect(hide_attacks) # Catch-all function that hides every weapon
	# once it has been triggered
	healthbar.visible = false

func _physics_process(delta: float) -> void:
	if health <= 0:
		kill_actor()
	
	healthbar.value = health
	
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
	if event.is_action_pressed("attack"):
		if not crossbow.visible and not slash.visible:
			if not crossbow_active:
				swing_attack()
			elif crossbow_active:
				crossbow_attack()
	if event.is_action_pressed("toggle_attack"):
		crossbow_active = !crossbow_active
		
func damage(dmg: float):
	if not healthbar.visible:
		healthbar.visible = true
	
	health -= dmg
	
func swing_attack():
	slash.visible = true
	slash.monitoring = true 
	
	attack_timer.start(slash_cooldown)
	
func crossbow_attack():
	if not crossbow.visible:
		crossbow.fire_arrows()
		crossbow.visible = true
		
	attack_timer.start(crossbow_cooldown)
	
func hide_attacks():
	slash.visible = false
	slash.monitoring = false
	
	crossbow.visible = false

func kill_actor():
	get_tree().change_scene_to_file("res://Maps/Menus/death.tscn")
