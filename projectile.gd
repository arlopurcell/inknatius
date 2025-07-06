class_name Projectile
extends RigidBody2D

var projectile_speed = 400.0
var power = 20.0
var range = 2000.0
var diameter = 20.0
var color = Color.BLUE

#var velocity = null
var start_position = Vector2.ZERO

static func fire(position: Vector2, velocity: Vector2, range: float, power: float, diameter: float, color: Color) -> Projectile:
	var scene = load("res://projectile.tscn")
	var projectile: Projectile = scene.instantiate()
	projectile.global_position = position
	projectile.start_position = position
	projectile.linear_velocity = velocity

	projectile.range = range
	projectile.power = power
	projectile.diameter = diameter
	projectile.color = color

	return projectile
	
func _ready() -> void:
	$Sprite2D.modulate = color
	$AnimationPlayer.play("spin")
	$CollisionShape2D.shape.radius = diameter / 2.0
	
	var scale = diameter / 128.0 # that's how big the sprite is
	$Sprite2D.scale.x = scale
	$Sprite2D.scale.y = scale
	

func _physics_process(delta):
	var collision = move_and_collide(linear_velocity * delta)
	if collision:
		do_collision(collision.get_collider())
	
	if global_position.distance_to(start_position) > range:
		queue_free()

func do_collision(body: Node) -> void:
	if body.is_in_group("hurtbox") and body.is_in_group("enemy_mob"):
		body.take_damage(power)
		queue_free()
	elif body.is_in_group("wall"):
		queue_free()
	else:
		pass
