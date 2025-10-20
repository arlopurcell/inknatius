extends VBoxContainer

func clear() -> void:
	populate(null)

func populate(weapon: Node) -> void:
	# clear previous
	for stat in $StatContainer.get_children():
		$StatContainer.remove_child(stat)
		stat.queue_free()
	
	if weapon:
		$CenterContainer/Name.text = weapon.display_name
		# TODO stats
		var stats = weapon.get_stats()
		for key in stats.keys():
			var container = HBoxContainer.new()
			
			var label = Label.new()
			label.text = key + ":"
			container.add_child(label)
			
			var value = Label.new()
			value.text = str(stats[key])
			container.add_child(value)
			
			$StatContainer.add_child(container)
	else:
		$CenterContainer/Name.text = "None Selected"
