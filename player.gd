extends CharacterBody2D

@export var speed = 400

var can_cast = true
var active_cast = null

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

	
func set_animation(animation: String):
	$BodySprite.animation = animation
	$EyesSprite.animation = animation
	$HatSprite.animation = animation
	$BeltSprite.animation = animation
	
func set_animation_flip_h(flip_h: bool):
	$BodySprite.flip_h = flip_h
	$EyesSprite.flip_h = flip_h
	$HatSprite.flip_h = flip_h
	$BeltSprite.flip_h = flip_h
	

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
	
	# casting
	if Input.is_action_pressed("arm_1") and can_cast:
		can_cast = false
		active_cast = "arm_1"
		# TODO decide direction
		if abs(input_direction.y) > abs(input_direction.x):
			if input_direction.y > 0:
				set_animation("attack_down")
			else:
				set_animation("attack_up")
		else:
			set_animation("attack_right")
			$SwordSprite.visible = true
			$WeaponAnimator.current_animation = "attack_right"
			
			$WeaponAnimator.play()
		$CastActivateTimer.start()
		$CastFinishTimer.start()

func _physics_process(delta):
	get_input()
	move_and_slide()


func _on_cast_activate_timer_timeout() -> void:
	# collide and stuff
	pass

func _on_cast_finish_timer_timeout() -> void:
	can_cast = true
	active_cast = null
	set_animation("idle")
	$SwordSprite.visible = false
