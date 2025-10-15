class_name CircleAoeDotWand
extends Node2D

var power = 10.0
signal attack_finished
var mana_cost = 0
var is_on = false
var mana_per_second = 2
var aoe_radius = 50.0

var enemies_in_aoe = {}

func _ready() -> void:
	# TODO make handle and head different colors?
	$Sprite2D.modulate = Color(0.6, 0.4, 0.7) # brown
	$AnimationPlayer.speed_scale = 2.0
	$AoeSprite.modulate = Color(1.0, 0.0, 0.0) # red
	# TODO set sizes of aoesprite and collider

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


func fire() -> void:
	is_on = !is_on
	$AoeSprite.visible = is_on
	$CollisionShape2D.disabled = !is_on

func do_effect() -> void:
	for enemy in enemies_in_aoe.keys():
		enemy.take_damage(power)

func _on_body_entered(body: Node2D) -> void:
	print("something entered aoe")
	if body.is_in_group("hurtbox") and body.is_in_group("enemy_mob"):
		print("enemy entered aoe")
		enemies_in_aoe[body] = true


func _on_body_exited(body: Node2D) -> void:
	print("enemy left aoe")
	enemies_in_aoe.erase(body)
