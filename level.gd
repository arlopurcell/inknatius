extends Node2D

@export var mob_scene: PackedScene

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("spawn_enemy"):
		var mob = mob_scene.instantiate()
		add_child(mob)
