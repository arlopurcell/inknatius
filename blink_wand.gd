class_name BlinkWand
extends Node2D

var range = 100.0

var face_direction = null

signal attack_finished

func _ready() -> void:
	# TODO make handle and head different colors?
	$Sprite2D.modulate = Color(0.6, 0.4, 0.7) # brown
	$AnimationPlayer.speed_scale = 2.0

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
	var player: Player = get_parent()
	player.position += face_direction * range
