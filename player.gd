extends CharacterBody2D

@export var speed = 400

var can_cast = true
var active_cast = null
var face_direction = Vector2.RIGHT

var max_health = 100
var current_health = max_health

signal health_changed
signal died

func _ready() -> void:
	$BodySprite.modulate = Color(1, 0.5, 0) # orange
	$HatSprite.modulate = Color(0.3, 0, 0.5) # purple
	$BeltSprite.modulate = Color(0.5, 0.3, 0.1) # brown
	$SwordSprite.modulate = Color(0.7, 0.7, 0.7) # gray

	set_animation("idle")
	$BodySprite.play()
	$EyesSprite.play()
	$HatSprite.play()
	$BeltSprite.play()
	
	$SwordSprite.visible = false
	$SwordCollider/CollisionPolygon2D.disabled = true


func set_animation(animation: String):
	$BodySprite.play(animation)
	$EyesSprite.play(animation)
	$HatSprite.play(animation)
	$BeltSprite.play(animation)
	
func set_animation_flip_h(flip_h: bool):
	$BodySprite.flip_h = flip_h
	$EyesSprite.flip_h = flip_h
	$HatSprite.flip_h = flip_h
	$BeltSprite.flip_h = flip_h
	
func take_damage(damage: int) -> void:
	var old_health = current_health
	current_health -= damage
	health_changed.emit()

func _on_health_changed() -> void:
	if current_health <= 0:
		# TODO die
		$DeathAnimator.play("death")

func get_input():
	# movement
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction.x > 0:
		set_animation_flip_h(false)
	elif input_direction.x < 0:
		set_animation_flip_h(true)
	
	# Don't animate movement if casting
	if active_cast == null:
		if input_direction.is_zero_approx():
			set_animation("idle")
		else:
			set_animation("move")
		
	velocity = input_direction * speed
	
	if not input_direction.is_zero_approx():
		face_direction = input_direction
	
	# casting
	if Input.is_action_pressed("arm_1") and can_cast:
		can_cast = false
		active_cast = "arm_1"
		if abs(face_direction.y) > abs(face_direction.x):
			if face_direction.y > 0:
				set_animation("attack_down")
				$WeaponAnimator.play("attack_down")
			else:
				set_animation("attack_up")
				$WeaponAnimator.play("attack_up")
		else:
			set_animation("attack_right")
			
			if face_direction.x > 0:
				$WeaponAnimator.play("attack_right")
			else:
				$WeaponAnimator.play("attack_left")


func _physics_process(delta):
	get_input()
	move_and_slide()


func _on_sword_collider_body_entered(body: Node2D) -> void:
	if body.is_in_group("hurtbox") and body.is_in_group("enemy_mob"):
		# TODO figure out how much damage to take
		body.take_damage(20)


func _on_weapon_animation_finished(anim_name: StringName) -> void:
	can_cast = true
	active_cast = null
	set_animation("idle")


func _on_death_animation_finished(anim_name: StringName) -> void:
	died.emit()
