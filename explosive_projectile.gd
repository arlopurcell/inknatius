class_name ExplosiveProjectile
extends RigidBody2D

var projectile_speed = 300.0
var power = 20.0
var range = 2000.0
var diameter = 20.0
var color = Color.ORANGE_RED
var explosion_diameter = 100.0

#var velocity = null
var start_position = Vector2.ZERO

static func fire(position: Vector2, velocity: Vector2, range: float, power: float, diameter: float, explosion_diameter: float, color: Color) -> ExplosiveProjectile:
	var scene = load("res://explosive_projectile.tscn")
	var projectile: ExplosiveProjectile = scene.instantiate()
	projectile.global_position = position
	projectile.start_position = position
	projectile.linear_velocity = velocity

	projectile.range = range
	projectile.power = power
	projectile.diameter = diameter
	projectile.explosion_diameter = explosion_diameter
	projectile.color = color

	return projectile
	
func _ready() -> void:
	$ProjectileSprite.modulate = color
	$AnimationPlayer.play("spin")
	$CollisionShape2D.shape.radius = diameter / 2.0
	
	var scale = diameter / 128.0 # that's how big the sprite is
	$ProjectileSprite.scale.x = scale
	$ProjectileSprite.scale.y = scale
	

func _physics_process(delta):
	var collision = move_and_collide(linear_velocity * delta)
	if collision:
		do_collision(collision.get_collider())
	
	if global_position.distance_to(start_position) > range:
		explode()

func do_collision(body: Node) -> void:
	if body.is_in_group("hurtbox") and body.is_in_group("enemy_mob"):
		explode()
	elif body.is_in_group("wall"):
		explode()


func explode() -> void:
	var explosion = Explosion.fire(global_position, power, explosion_diameter, color)
	get_parent().get_parent().add_child(explosion)
	queue_free()
