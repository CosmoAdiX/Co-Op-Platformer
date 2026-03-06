extends Node

var username := ''
var forest: Node3D
var spawn_container: Node3D

const ball_1 = preload("uid://cn6fmbuyc1jyh")

@rpc("any_peer")
func shoot_ball(pos, dir, force):
	var new_ball: RigidBody3D = ball_1.instantiate()
	new_ball.position = pos + Vector3(0.0, 1.0, 0.0) + (dir * 2.0)
	spawn_container.add_child(new_ball, true)
	new_ball.apply_central_impulse(dir * force)
