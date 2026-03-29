extends CharacterBody3D

@export var health := 100
@export var animation_player_dummy: AnimationPlayer
@export var dummy_mesh: MeshInstance3D

func _ready():
	add_to_group('Targets')
	look_at(goal_position)
	

func take_damage(damage: int, source: int):
	var next_health = health - damage
	
	
	var player_to_notify: Player
	for current_player in get_tree().get_nodes_in_group('Players'):
		if current_player.name == str(source):
			player_to_notify = current_player
			break
	
	if not player_to_notify:
		return
	
	if next_health <= 0:
		queue_free()
		player_to_notify.register_hit.rpc_id(source, true)
	else:
		health = next_health
		player_to_notify.register_hit.rpc_id(source)
		


var SPEED := 1.8
var direction := Vector3.ZERO
var goal_position := Vector3.ZERO


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if position.distance_to(goal_position) > 3.0:
		direction = position.direction_to(goal_position)
		animation_player_dummy.play("Walk_Formal")
	else:
		direction = Vector3.ZERO
		animation_player_dummy.play("Spell_Simple_Shoot")
		
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
	
	
	
	
	
	
	
