class_name BlinkWand
extends Node2D

var range = 100.0
var mana_cost = 10

var face_direction = null

# not a toggle wand
const is_on = false

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
	player.velocity = face_direction * range * 100
	player.set_collision_mask_value(2, false)
	player.move_and_slide()
	player.set_collision_mask_value(2, true)
	player.velocity = Vector2.ZERO
