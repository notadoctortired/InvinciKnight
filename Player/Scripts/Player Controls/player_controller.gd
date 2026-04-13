extends CharacterBody3D

@export_category("Player Values")
@export var health: float
@export var speed: float
@export var sfx_variance_min: float
@export var sfx_variance_max: float

@export_category("Attack Values")
@export var damage_mult: float
@export var slash_cooldown: float
@export var crossbow_cooldown: float

# Attack Variables
@onready var crossbow = $Meshes/Crossbow
@onready var slash = $SlashArea
@onready var attack_timer = $Timer
var crossbow_active = false

# UI Variables
@onready var player_ui = $PlayerUI
@onready var healthbar = $PlayerUI/Healthbar
@onready var healthbar_texture = $PlayerUI/HealthbarTex

# SFX Variables
@onready var walking_sfx = $SFX/WalkingSFX
var walking_playback = 0
@onready var sword_sfx = $SFX/SwordSwooshSFX
@onready var crossbow_sfx = $SFX/CrossbowFiringSFX

# Mesh / Animation Variables
@onready var meshes = $Meshes
@onready var animation_player = meshes.get_node("PlayerModel/AnimationPlayer")
var anim: Animation

func _ready():
	# Default Anim Player settings on load
	animation_player.playback_default_blend_time = .3
	animation_player.play(&"Idle")
	anim = animation_player.get_animation(&"Idle")
	anim.loop_mode = Animation.LOOP_LINEAR
	
	attack_timer.timeout.connect(hide_attacks) # Catch-all function that hides every weapon
	# once it has been triggered
	healthbar.visible = false
	healthbar_texture.visible = false
	
	walking_sfx.stream.loop = true

func _physics_process(delta: float) -> void:
	if health <= 0:
		kill_actor()

	if health < 100:
		health += 0.02
	
	healthbar.value = lerp(healthbar.value, health, 0.4)
	
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
	
	if velocity != Vector3.ZERO and not walking_sfx.playing:
		walking_sfx.play(walking_playback)
		
		animation_player.play(&"Running In-place")
		anim = animation_player.get_animation(&"Running In-place")
		anim.loop_mode = Animation.LOOP_LINEAR
		
		
	elif velocity == Vector3.ZERO and walking_sfx.playing:
		walking_playback = walking_sfx.get_playback_position()
		walking_sfx.stop()
		
		animation_player.play(&"Idle")
		anim = animation_player.get_animation(&"Idle")
		anim.loop_mode = Animation.LOOP_LINEAR
	
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
		
		if crossbow_active:
			var selected_attack = player_ui.get_node("CrossbowAttack/Unselected")
			var unselected_attack = player_ui.get_node("SwordAttack/Unselected")
			
			selected_attack.visible = false
			unselected_attack.visible = true
		elif not crossbow_active:
			var selected_attack = player_ui.get_node("SwordAttack/Unselected")
			var unselected_attack = player_ui.get_node("CrossbowAttack/Unselected")
			
			selected_attack.visible = false
			unselected_attack.visible = true
		
func damage(dmg: float):
	if not healthbar.visible:
		healthbar.visible = true
		healthbar_texture.visible = true
	
	health -= dmg
	
func swing_attack():
	slash.visible = true
	slash.monitoring = true 
	
	sword_sfx.pitch_scale = 1 + randf_range(sfx_variance_min,sfx_variance_max)
	sword_sfx.play()
	attack_timer.start(slash_cooldown)
	
func crossbow_attack():
	if not crossbow.visible:
		crossbow.fire_arrows()
		crossbow.visible = true
	
	crossbow_sfx.pitch_scale = 1 + randf_range(sfx_variance_min,sfx_variance_max)
	crossbow_sfx.play()
	attack_timer.start(crossbow_cooldown)
	
func hide_attacks():
	slash.visible = false
	slash.monitoring = false
	
	crossbow.visible = false

func kill_actor():
	get_tree().change_scene_to_file("res://Maps/Menus/death.tscn")
