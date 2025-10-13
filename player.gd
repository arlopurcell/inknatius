class_name Player
extends CharacterBody2D

@export var speed = 400

var can_cast = true
var active_cast = null
var face_direction = Vector2.RIGHT

var max_health = 300
var current_health = max_health

var max_mana = 300
var current_mana = max_mana
var mana_regen_frames = 30
var mana_regen = 3

signal health_changed
signal mana_changed
signal died

var arm_1_weapon = null
var arm_2_weapon = null
var arm_3_weapon = null

const dead_zone_threshold = 0.2

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
	
	# temp add blinkn on arm 3
	var blink_scene = load("res://blink_wand.tscn")
	arm_3_weapon = blink_scene.instantiate()
	arm_3_weapon.attack_finished.connect(_on_attack_finished)
	add_child(arm_3_weapon)


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
	var in_dead_zone = input_direction.length() < dead_zone_threshold
	
	# Don't animate movement if casting
	if active_cast == null:
		if in_dead_zone:
			set_animation("idle")
		else:
			set_animation("move")
	
	if not in_dead_zone:
		velocity = input_direction * speed
		face_direction = input_direction.normalized()
		if input_direction.x > 0:
			set_animation_flip_h(false)
		elif input_direction.x < 0:
			set_animation_flip_h(true)
	else:
		velocity = Vector2.ZERO
	
	# casting
	if Input.is_action_pressed("arm_1") and can_cast and arm_1_weapon != null:
		if use_mana(arm_1_weapon.mana_cost):
			can_cast = false
			active_cast = "arm_1"
			arm_1_weapon.trigger(face_direction)
			set_animation_for_cast()
			
	if Input.is_action_pressed("arm_2") and can_cast and arm_2_weapon != null:
		if use_mana(arm_2_weapon.mana_cost):
			can_cast = false
			active_cast = "arm_2"
			arm_2_weapon.trigger(face_direction)
			set_animation_for_cast()
			
	if Input.is_action_pressed("arm_3") and can_cast and arm_3_weapon != null:
		if use_mana(arm_3_weapon.mana_cost):
			can_cast = false
			active_cast = "arm_3"
			arm_3_weapon.trigger(face_direction)
			set_animation_for_cast()

func use_mana(cost: int) -> bool:
	if current_mana >= cost:
		current_mana -= cost
		mana_changed.emit()
		return true
	else:
		return false

func set_animation_for_cast() -> void:
	if abs(face_direction.y) > abs(face_direction.x):
		if face_direction.y > 0:
			set_animation("attack_down")
		else:
			set_animation("attack_up")
	else:
		set_animation("attack_right")

func _physics_process(delta):
	get_input()
	do_passive()
	move_and_slide()

func do_passive() -> void:
	# Regen mana
	if Engine.get_process_frames() % mana_regen_frames == 0:
		var new_mana = current_mana + mana_regen
		new_mana = min(max_mana, new_mana)
		if new_mana != current_mana:
			current_mana = new_mana
			mana_changed.emit()

func _on_death_animation_finished(anim_name: StringName) -> void:
	died.emit()


func _on_attack_finished() -> void:
	can_cast = true
	active_cast = null
	set_animation("idle")
