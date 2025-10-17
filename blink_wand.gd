class_name BlinkWand
extends Node2D

var spell_range = 100.0
var mana_cost = 10

var face_direction = null

# not a toggle wand
const is_on = false

signal attack_finished

func configure(params: Dictionary) -> BlinkWand:
	mana_cost = params.get("mana_cost", 10)
	spell_range = params.get("spell_range", 100.0)
	$AnimationPlayer.speed_scale = params.get("speed_scale", 2.0)
	$Sprite.modulate = params.get("color", Color(0.6, 0.4, 0.7)) # default brown
	
	return self

func _on_animation_finished(_anim_name: StringName) -> void:
	attack_finished.emit()
	
func trigger(new_direction: Vector2) -> void:
	if abs(new_direction.y) > abs(new_direction.x):
		if new_direction.y > 0:
			$AnimationPlayer.play("attack_down")
		else:
			$AnimationPlayer.play("attack_up")
	else:
		if new_direction.x > 0:
			$AnimationPlayer.play("attack_right")
		else:
			$AnimationPlayer.play("attack_left")
	
	face_direction = new_direction


func fire() -> void:
	var player: Player = get_parent()
	player.velocity = face_direction * spell_range * 100
	player.set_collision_mask_value(2, false)
	player.move_and_slide()
	player.set_collision_mask_value(2, true)
	player.velocity = Vector2.ZERO
