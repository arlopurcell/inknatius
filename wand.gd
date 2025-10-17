class_name Wand
extends Node2D

var mana_cost = 20
var power = 50.0
var range = 400.0
var projectile_speed = 400.0
var diameter = 60.0

# not a toggle wand
const is_on = false

var face_direction = null

signal attack_finished

func configure(params: Dictionary) -> Wand:
	power = params.get("power", 50.0)
	mana_cost = params.get("mana_cost", 20)
	range = params.get("range", 400.0)
	projectile_speed = params.get("projectile_speed", 400.0)
	diameter = params.get("diameter", 60.0)
	$AnimationPlayer.speed_scale = params.get("speed_scale", 1.0)
	$Sprite.modulate = params.get("color", Color(0.6, 0.4, 0.7)) # default brown
	
	return self

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
	var projectile = Projectile.fire(
		global_position + face_direction * 100.0, 
		face_direction * projectile_speed, 
		range, 
		power,
		diameter,
		Color.ORANGE,
	)
	get_parent().get_parent().add_child(projectile)
