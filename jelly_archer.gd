class_name JellyArcher
extends RigidBody2D

var speed = 200

var velocity = Vector2.RIGHT

var max_health = 30
var current_health = max_health

signal health_changed(old_value: int, new_value: int)
signal died(location: Vector2)

var is_attacking = false
var max_attack_distance = 1000
var min_attack_distance = 300

var ai_freq_frames = 60
var ai_freq_offset = 0

var power = 10
var arrow_range = 1000
var attack_target = Vector2.ZERO

var visible_enemies = {}

func configure(params: Dictionary) -> void:
	var speed_scale = params.get("speed_scale", 1.0)
	$BodySprite.speed_scale = speed_scale
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
		if $NavigationAgent2D.is_navigation_finished():
			var attacked = false
			for enemy in visible_enemies.keys():
				var distance = global_position.distance_to(enemy.global_position)
				if distance > min_attack_distance and distance < max_attack_distance:
					attack(enemy.global_position)
					attacked = true
					break
			if not attacked:
				# find new destination
				var enemy = nearest_enemy()
				if enemy:
					var direction_to_enemy = global_position.direction_to(enemy.global_position).normalized()
					if global_position.distance_to(enemy.global_position) > min_attack_distance:
						# we're too far from enemy and must move towards them
						$NavigationAgent2D.target_position = global_position + (direction_to_enemy * max_attack_distance)
					else:
						# we're too close and must move away
						$NavigationAgent2D.target_position = global_position + (-direction_to_enemy * min_attack_distance)

func attack(target: Vector2) -> void:
	is_attacking = true
	$AttackFireTimer.start()
	$FullAttackTimer.start()
	attack_target = target
	var direction = global_position.direction_to(target)
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			$BodySprite.flip_h = true
			$BodySprite.play("attack_left")
		else:
			$BodySprite.flip_h = false
			$BodySprite.play("attack_left")
	else:
		if direction.y > 0:
			$BodySprite.flip_h = false
			$BodySprite.play("attack_down")
		else:
			$BodySprite.flip_h = false
			$BodySprite.play("attack_up")

func _on_attack_timer_timeout() -> void:
	var direction = global_position.direction_to(attack_target).normalized()
	var arrow = Arrow.fire(global_position + direction * speed / 4, direction * speed, arrow_range, power)
	get_parent().add_child(arrow)

func _on_full_attack_timer_timeout() -> void:
	is_attacking = false
	$BodySprite.play("idle")

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
			$BodySprite.flip_h = false
		else:
			$BodySprite.flip_h = true
	elif not is_attacking:
		$BodySprite.play("idle")
	if move_and_collide(velocity * delta) != null:
		# If we collided with something (a wall), stop trying to go through it
		$NavigationAgent2D.target_position = global_position


func _on_attack_animation_finished(_anim_name: StringName) -> void:
	is_attacking = false

func _on_vision_collider_body_entered(body: Node2D) -> void:
	if body.is_in_group("player_mob"):
		visible_enemies[body] = null

func _on_vision_collider_body_exited(body: Node2D) -> void:
	if body.is_in_group("player_mob"):
		visible_enemies.erase(body)
