class_name Arrow
extends RigidBody2D

var power = 20.0
var range = 1000.0
var start_position = Vector2.ZERO

static func fire(position: Vector2, velocity: Vector2, range: float, power: float) -> Arrow:
	var scene = load("res://arrow.tscn")
	var arrow: Arrow = scene.instantiate()
	arrow.global_position = position
	arrow.start_position = position
	arrow.linear_velocity = velocity
	arrow.look_at(position + velocity)

	arrow.range = range
	arrow.power = power

	return arrow

func _physics_process(delta):
	var collision = move_and_collide(linear_velocity * delta)
	if collision:
		do_collision(collision.get_collider())
	
	if global_position.distance_to(start_position) > range:
		queue_free()

func do_collision(body: Node) -> void:
	if body.is_in_group("hurtbox") and body.is_in_group("player_mob"):
		body.take_damage(power)
		queue_free()
	else:
		queue_free()
