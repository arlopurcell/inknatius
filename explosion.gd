class_name Explosion
extends Area2D

var power = 20.0
var diameter = 100.0
var color = Color.ORANGE_RED

static func fire(position: Vector2, power: float, diameter: float, color: Color) -> Explosion:
	var scene = load("res://explosion.tscn")
	var explosion: Explosion = scene.instantiate()
	
	explosion.global_position = position
	explosion.power = power
	explosion.diameter = diameter
	explosion.color = color

	return explosion
	
func _ready() -> void:
	$AnimatedSprite2D.modulate = color
	$CollisionShape2D.shape.radius = diameter / 2.0
	
	var scale = diameter / 128.0 # that's how big the sprite is
	$AnimatedSprite2D.scale.x = scale
	$AnimatedSprite2D.scale.y = scale

func _on_animation_finished() -> void:
	for body in get_overlapping_bodies():
		if body.is_in_group("hurtbox") and body.is_in_group("enemy_mob"):
			body.take_damage(power)
	queue_free()
