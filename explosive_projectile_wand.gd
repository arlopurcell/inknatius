class_name ExplosiveProjectileWand
extends Node2D

var mana_cost = 20
var power = 50.0
var range = 400.0
var projectile_speed = 400
var diameter = 40.0
var explosion_diameter = 100.0

# not a toggle wand
const is_on = false

var face_direction = null

signal attack_finished

func _ready() -> void:
	# TODO make handle and head different colors?
	$Sprite2D.modulate = Color(0.6, 0.4, 0.7) # brown

func configure(params: Dictionary) -> void:
	var speed_scale = params.get("speed_scale", 1.0)
	$AnimationPlayer.speed_scale = speed_scale


func _on_animation_finished(anim_name: StringName) -> void:
	attack_finished.emit()
	
func trigger(face_direction: Vector2) -> void:
	if abs(face_direction.y) > abs(face_direction.x):
		if face_direction.y > 0:
			$AnimationPlayer.play("attack_down")
		else:
			$AnimationPlayer.play("attack_up")
	else:
		if face_direction.x > 0:
			$AnimationPlayer.play("attack_right")
		else:
			$AnimationPlayer.play("attack_left")
	
	self.face_direction = face_direction


func fire() -> void:
	var projectile = ExplosiveProjectile.fire(
		global_position + face_direction * 100.0, 
		face_direction * projectile_speed, 
		range, 
		power,
		diameter,
		explosion_diameter,
		Color.ORANGE,
	)
	get_parent().get_parent().add_child(projectile)
