class_name CircleAoeDotWand
extends Node2D

var power = 10.0
var mana_cost = 0
var mana_per_second = 4
var aoe_radius = 50.0

var is_on = false
var enemies_in_aoe = {}
signal attack_finished

func configure(params: Dictionary) -> CircleAoeDotWand:
	power = params.get("power", 10.0)
	mana_cost = params.get("mana_cost", 0)
	mana_per_second = params.get("mana_per_second", 2)
	aoe_radius = params.get("aoe_radius", 50.0)
	$AnimationPlayer.speed_scale = params.get("speed_scale", 2.0)
	$Sprite.modulate = params.get("color", Color(0.6, 0.4, 0.7)) # default brown
	$AoeSprite.modulate = params.get("aoe_color", Color(1.0, 0.4, 0.0)) # default orange

	$CollisionShape2D.shape.radius = aoe_radius
	var scale = (aoe_radius * 2) / 128.0 # that's how big the sprite is
	$AoeSprite.scale.x = scale
	$AoeSprite.scale.y = scale
	
	return self

func _on_animation_finished(_anim_name: StringName) -> void:
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
	if body.is_in_group("hurtbox") and body.is_in_group("enemy_mob"):
		enemies_in_aoe[body] = true

func _on_body_exited(body: Node2D) -> void:
	enemies_in_aoe.erase(body)
