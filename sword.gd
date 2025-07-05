class_name Sword
extends Area2D

var power = 20.0
signal attack_finished

func _ready() -> void:
	$Sprite.modulate = Color(0.7, 0.7, 0.7) # gray


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("hurtbox") and body.is_in_group("enemy_mob"):
		body.take_damage(power)

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
