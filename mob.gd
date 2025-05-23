extends RigidBody2D

@export var max_health = 100
var current_health = max_health

signal health_changed(old_value: int, new_value: int)

func take_damage(damage: int) -> void:
	var old_health = current_health
	current_health -= damage
	health_changed.emit(old_health, current_health)


func _on_health_changed(old_value: int, new_value: int) -> void:
	$HealthBar.value = (current_health as float / max_health as float) * 100.0
	if new_value <= 0:
		queue_free()
