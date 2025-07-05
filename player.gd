class_name Player
extends CharacterBody2D

@export var speed = 400

var can_cast = true
var active_cast = null
var face_direction = Vector2.RIGHT

var max_health = 300
var current_health = max_health

signal health_changed
signal died

var arm_1_weapon = null
var arm_2_weapon = null

func _ready() -> void:
	$BodySprite.modulate = Color(1, 0.5, 0) # orange
	$HatSprite.modulate = Color(0.3, 0, 0.5) # purple
	$BeltSprite.modulate = Color(0.5, 0.3, 0.1) # brown

	set_animation("idle")
	$BodySprite.play()
	$EyesSprite.play()
	$HatSprite.play()
	$BeltSprite.play()
	
	# temp add sword on arm 1
	var sword_scene = load("res://sword.tscn")
	arm_1_weapon = sword_scene.instantiate()
	arm_1_weapon.attack_finished.connect(_on_attack_finished)
	add_child(arm_1_weapon)

	# temp add wand on arm 2
	var wand_scene = load("res://wand.tscn")
	arm_2_weapon = wand_scene.instantiate()
	arm_2_weapon.attack_finished.connect(_on_attack_finished)
	add_child(arm_2_weapon)


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
	if Input.is_action_pressed("arm_1") and can_cast and arm_1_weapon != null:
		can_cast = false
		active_cast = "arm_1"
		arm_1_weapon.trigger(face_direction)
		if abs(face_direction.y) > abs(face_direction.x):
			if face_direction.y > 0:
				set_animation("attack_down")
			else:
				set_animation("attack_up")
		else:
			set_animation("attack_right")
			
	if Input.is_action_pressed("arm_2") and can_cast and arm_2_weapon != null:
		can_cast = false
		active_cast = "arm_2"
		arm_2_weapon.trigger(face_direction)
		if abs(face_direction.y) > abs(face_direction.x):
			if face_direction.y > 0:
				set_animation("attack_down")
			else:
				set_animation("attack_up")
		else:
			set_animation("attack_right")


func _physics_process(delta):
	get_input()
	move_and_slide()


func _on_death_animation_finished(anim_name: StringName) -> void:
	died.emit()


func _on_attack_finished() -> void:
	can_cast = true
	active_cast = null
	set_animation("idle")
