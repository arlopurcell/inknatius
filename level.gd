extends Node2D

@export var mob_scene: PackedScene

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn_enemy"):
		var mob = mob_scene.instantiate()
		add_child(mob)
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = true
		$PauseMenu.show()


func _on_player_health_changed() -> void:
	$HUD/HealthBar.value = ($Player.current_health as float / $Player.max_health as float) * 100.0


func _on_resume_pressed() -> void:
	$PauseMenu.hide()
	get_tree().paused = false
	

func _on_exit_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_menu.tscn")
	

func _on_exit_to_desktop_pressed() -> void:
	get_tree().quit()


func _on_player_died() -> void:
	$DeathMenu.show()
	get_tree().paused = true
