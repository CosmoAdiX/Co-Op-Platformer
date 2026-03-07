extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 10.5


@onready var camera3d_1: Camera3D = %Camera3D
@onready var head_1: Node3D = %Head
#@onready var head_2: MeshInstance3D = %headNose
@onready var nameplate_1: Label3D = %Nameplate

# Player menu UI
@onready var menu: Control = %Menu
@onready var leave_button: Button = %LeaveButton
@onready var label_session: Label = %LabelSession
@onready var button_copy_session: Button = %ButtonCopySession


@export var sensitivity: float = 0.002

var immobile := false

func _enter_tree() -> void:
	set_multiplayer_authority(int(name))

func _ready():
	menu.hide()
	add_to_group("Players")	
	nameplate_1.text = name
	
	if not is_multiplayer_authority():
		set_process(false)
		set_physics_process(false)
		return
		
	label_session.text = Network.tube_client.session_id
	camera3d_1.current = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	leave_button.pressed.connect(func(): Network.leave_server())
	button_copy_session.pressed.connect(func(): DisplayServer.clipboard_set(Network.tube_client.session_id))
	DisplayServer.clipboard_set(Network.tube_client.session_id)

func _unhandled_input(event: InputEvent) -> void:
	if not is_multiplayer_authority():
		return
	
	if event is InputEventMouseMotion:
		head_1.rotate_y(-event.relative.x * sensitivity)
		camera3d_1.rotate_x(-event.relative.y * sensitivity)
		camera3d_1.rotation.x = clamp(camera3d_1.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('menu'):
		open_menu(menu.visible)
		
	if immobile:
		return
		
	if Input.is_action_just_pressed('shoot'):
		shoot()
		
func open_menu(current_visisbility: bool):
	menu.visible = !current_visisbility
	
	immobile = menu.visible
	if menu.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (head_1.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if immobile:
		direction = Vector3.ZERO
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func shoot():
	var facing_dir = -head_1.transform.basis.z
	var force = 50
	var pos = global_position
	
	Global.shoot_ball.rpc_id(1, pos, facing_dir, force)
	
func get_shoot_direction():
	var viewport_rect = get_viewport().get_visible_rect().size
	var raycast_start = camera3d_1.project_ray_origin(viewport_rect / 2)
	var raycast_end = raycast_start + camera3d_1.project_ray_normal(viewport_rect / 2) * 200
	return -(raycast_start - raycast_end).normalized()
