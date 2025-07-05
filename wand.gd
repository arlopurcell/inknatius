class_name Wand
extends Node2D

@export var power = 20.0
@export var range = 400.0
@export var projectile_speed = 400

var face_direction = null

signal attack_finished

#func _ready() -> void:
#	$Sprite.modulate = Color(0.7, 0.7, 0.7) # gray

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
	var projectile = Projectile.fire(global_position + face_direction * 100.0, face_direction * projectile_speed, range, power)
	get_parent().get_parent().add_child(projectile)
