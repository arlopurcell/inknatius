extends VBoxContainer

func populate(weapon: Node) -> void:
	$CenterContainer/Name.text = weapon.display_name
	# TODO stats
