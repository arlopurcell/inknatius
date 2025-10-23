class_name ExplosiveProjectileWand
extends Node2D

var mana_cost = 20
var power = 50.0
var spell_range = 400.0
var projectile_speed = 400
var diameter = 40.0
var explosion_diameter = 100.0
var display_name = "Explosive Projectile"
var materials = {}

# not a toggle wand
const is_on = false

var face_direction = null

signal attack_finished

func configure(materials: Dictionary, params: Dictionary) -> ExplosiveProjectileWand:
	self.materials = materials
	display_name = params.get("display_name", "Explosive Projectile")
	power = params.get("power", 50.0)
	mana_cost = params.get("mana_cost", 40)
	spell_range = params.get("spell_range", 400.0)
	projectile_speed = params.get("projectile_speed", 400.0)
	diameter = params.get("diameter", 40.0)
	explosion_diameter = params.get("explosion_diameter", 100.0)
	$AnimationPlayer.speed_scale = params.get("speed_scale", 1.0)
	$Sprite.modulate = params.get("color", Color(0.6, 0.4, 0.7)) # default brown

	return self

func get_stats() -> Dictionary:
	return {
		"Mana Cost": mana_cost,
		"Damage": power,
		"Range": spell_range,
		"Projectile Speed": projectile_speed,
		"Projectile Diameter": diameter,
		"Explosion Diameter": explosion_diameter,
	}

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
	var projectile = ExplosiveProjectile.fire(
		global_position + face_direction * 100.0, 
		face_direction * projectile_speed, 
		spell_range, 
		power,
		diameter,
		explosion_diameter,
		Color.ORANGE,
	)
	get_parent().get_parent().add_child(projectile)
