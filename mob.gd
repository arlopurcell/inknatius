class_name Mob
extends RigidBody2D

var speed = 200

var velocity = Vector2.RIGHT

@export var max_health = 30
var current_health = max_health
var power = 10

signal health_changed(old_value: int, new_value: int)
signal died(location: Vector2)

var is_attacking = false
@export var attack_distance = 120
@export var attack_velocity = 0

@export var ai_freq_frames = 60
@export var ai_freq_offset = 0

var flip_h_offset = -40

var visible_enemies = {}

func configure(params: Dictionary) -> void:
	var speed_scale = params.get("speed_scale", 1.0)
	$BodySprite.speed_scale = speed_scale
	$AttackAnimation.speed_scale = speed_scale
	speed *= speed_scale

func take_damage(damage: int) -> void:
	var old_health = current_health
	current_health -= damage
	health_changed.emit(old_health, current_health)


func _on_health_changed(_old_value: int, new_value: int) -> void:
	$HealthBar.value = (current_health as float / max_health as float) * 100.0
	if new_value <= 0:
		died.emit(global_position)
		queue_free()
		
func ai_process():
	if is_attacking:
		# if attacking do nothing, motion continues
		pass
	else:
		var enemy = nearest_enemy()
		if enemy == null:
			$NavigationAgent2D.target_position = global_position
		else:
			if global_position.distance_to(enemy.global_position) < attack_distance:
				$NavigationAgent2D.target_position = global_position
				is_attacking = true
				# If in position to attack, do it. start animations and set motion
				var enemy_direction = global_position.direction_to(enemy.global_position)
				if abs(enemy_direction.x) > abs(enemy_direction.y):
					if enemy_direction.x > 0:
						$BodySprite.flip_h = false
						$BodySprite.offset.x = 0
						$BodySprite.play("attack_right")
						$AttackAnimation.play("attack_right")
						velocity = Vector2.RIGHT * attack_velocity
					else:
						$BodySprite.flip_h = true
						$BodySprite.offset.x = flip_h_offset
						$BodySprite.play("attack_right")
						$AttackAnimation.play("attack_right")
						velocity = Vector2.LEFT * attack_velocity
				else:
					if enemy_direction.y > 0:
						$BodySprite.flip_h = false
						$BodySprite.offset.x = 0
						$BodySprite.play("attack_down")
						$AttackAnimation.play("attack_down")
						velocity = Vector2.DOWN * attack_velocity
					else:
						$BodySprite.flip_h = false
						$BodySprite.offset.x = 0
						$BodySprite.play("attack_up")
						$AttackAnimation.play("attack_up")
						velocity = Vector2.UP * attack_velocity
			else:
				# else if in vision range of player, navigate towards them
				$NavigationAgent2D.target_position = enemy.global_position
				#var path_point = $NavigationAgent2D.get_next_path_position()
				#velocity = global_position.direction_to(path_point) * speed

func nearest_enemy() -> PhysicsBody2D:
	var closest_enemy = null
	var closest_distance = INF
	for enemy in visible_enemies.keys():
		var distance = global_position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	return closest_enemy

func _physics_process(delta):
	if Engine.get_process_frames() % ai_freq_frames == ai_freq_offset:
		ai_process()
	if not $NavigationAgent2D.is_navigation_finished():
		var path_point = $NavigationAgent2D.get_next_path_position()
		velocity = global_position.direction_to(path_point) * speed
		$BodySprite.animation = "move"
		if velocity.x < 0:
			$BodySprite.flip_h = true
			$BodySprite.offset.x = flip_h_offset
		else:
			$BodySprite.flip_h = false
			$BodySprite.offset.x = 0
	elif not is_attacking:
		$BodySprite.play("idle")
	move_and_collide(velocity * delta)


func _on_attack_animation_finished(_anim_name: StringName) -> void:
	is_attacking = false

func _on_vision_collider_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_mob"):
		visible_enemies[body] = null

func _on_vision_collider_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_mob"):
		visible_enemies.erase(body)
		
func _on_attack_collider_body_entered(body: Node2D) -> void:
	if body.is_in_group("hurtbox") and body.is_in_group("player_mob"):
		# TODO figure out how much damage to take
		body.take_damage(power)
