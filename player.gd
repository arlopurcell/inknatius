class_name Player
extends CharacterBody2D

@export var speed = 400

var can_cast = true
var active_cast = null
var face_direction = Vector2.RIGHT

var max_health = 50
var current_health = max_health

var max_mana = 50
var current_mana = max_mana
var mana_regen_frames = 30
var mana_regen = 2

signal health_changed
signal mana_changed
signal died

var arm_weapons = [null, null, null, null, null, null, null, null] # 8 arms
var inventory_weapons = [null, null, null, null, null, null, null, null] # 8 inventory slots

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
	
	# temp add weapons
	set_arm_weapon(0, load("res://blink_wand.tscn").instantiate().configure({}))
	set_arm_weapon(1, load("res://explosive_projectile_wand.tscn").instantiate().configure({}))
	set_arm_weapon(2, load("res://sword.tscn").instantiate().configure({}))
	set_arm_weapon(3, load("res://circle_aoe_dot_wand.tscn").instantiate().configure({"aoe_radius": 100.0}))
	
	inventory_weapons[0] = load("res://wand.tscn").instantiate().configure({})
	inventory_weapons[1] = load("res://explosive_projectile_wand.tscn").instantiate().configure({
		"display_name": "Explosive Trap",
		"projectile_speed": 1.0
	})

func set_arm_weapon(arm_index: int, weapon: Node) -> void:
	if arm_weapons[arm_index]:
		remove_child(arm_weapons[arm_index])

	arm_weapons[arm_index] = weapon

	if weapon:
		weapon.attack_finished.connect(_on_attack_finished)
		add_child(weapon)

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
			velocity = Vector2.ZERO

		else:
			set_animation("move")
			velocity = input_direction * speed
			face_direction = input_direction.normalized()
			if input_direction.x > 0:
				set_animation_flip_h(false)
			elif input_direction.x < 0:
				set_animation_flip_h(true)
	else:
		velocity = Vector2.ZERO
	
	# casting
	handle_arm_input(0)
	handle_arm_input(1)
	handle_arm_input(2)
	handle_arm_input(3)

func handle_arm_input(index: int) -> void:
	if Input.is_action_pressed("arm_" + str(index)) and can_cast and arm_weapons[index] != null:
		if use_mana(arm_weapons[index].mana_cost):
			can_cast = false
			active_cast = "arm_" + str(index)
			arm_weapons[index].trigger(face_direction)
			set_animation_for_cast()
		else:
			show_message("Insufficient Mana")

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

func _physics_process(_delta):
	get_input()
	move_and_slide()

func _on_death_animation_finished(_anim_name: StringName) -> void:
	died.emit()


func _on_attack_finished() -> void:
	can_cast = true
	active_cast = null
	set_animation("idle")


func _per_second_process() -> void:
	# Regen mana
	var new_mana = current_mana + mana_regen
	# deduct toggled wands
	for wand in arm_weapons:
		if wand and wand.is_on:
			new_mana -= wand.mana_per_second
	
	new_mana = min(max_mana, new_mana)
	if new_mana != current_mana:
		current_mana = new_mana
		mana_changed.emit()
		
	# do toggled wand effects
	for wand in arm_weapons:
		if wand and wand.is_on:
			wand.do_effect()

func show_message(msg: String) -> void:
	$MessageLabel.text = msg
	$MessageLabel.show()
	$MessageTimer.start(1.0)

func _on_message_timer_timeout() -> void:
	$MessageLabel.hide()
