extends RigidBody3D

@onready var area3d_1: Area3D = $Area3D


func _ready() -> void:
	area3d_1.body_entered.connect(on_ball_hit)
	
func on_ball_hit(body: Node3D):
	if body.is_in_group('Players'):
		queue_free()
 
