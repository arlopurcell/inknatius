extends MarginContainer


func _on_new_game_button_pressed() -> void:
	var new_level = Level.new_level(1)

	var tree = get_tree()
	var cur_scene = tree.get_current_scene()
	tree.get_root().add_child(new_level)
	tree.get_root().remove_child(cur_scene)
	tree.set_current_scene(new_level)


func _on_exit_button_pressed() -> void:
	get_tree().quit()
