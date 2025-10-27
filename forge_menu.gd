extends CanvasLayer

var player: Player = null

var new_weapon_type = Forge.WeaponType.Melee
var selected_weapon_from_arms = false
var selected_weapon_index: int = -1

var current_materials = {}
var available_materials = {}

func _ready() -> void:
	pass
	

func configure(player: Player) -> void:
	self.player = player
	
	# remove all children
	for child in $WeaponsContainer/VBoxContainer.get_children():
		$WeaponsContainer/VBoxContainer.remove_child(child)
	
	# Buttons for arm weapons
	for weapon_index in range(8):
		var weapon = player.arm_weapons[weapon_index]
		if weapon:
			var button = Button.new()
			button.text = weapon.display_name
			button.connect("pressed", func(): _on_weapon_button_pressed(true, weapon_index))
			button.connect("focus_entered", func(): _on_weapon_focus_entered(true, weapon_index))
			button.connect("gui_input", _on_weapon_button_gui_input)
			$WeaponsContainer/VBoxContainer.add_child(button)
	
	# Buttons for inventory weapons
	for weapon_index in range(8):
		var weapon = player.inventory_weapons[weapon_index]
		if weapon:
			var button = Button.new()
			button.text = weapon.display_name
			button.connect("pressed", func(): _on_weapon_button_pressed(false, weapon_index))
			button.connect("focus_entered", func(): _on_weapon_focus_entered(false, weapon_index))
			button.connect("gui_input", _on_weapon_button_gui_input)
			$WeaponsContainer/VBoxContainer.add_child(button)
			
	# Buttons for forge new weapon
	var melee_weapon_button = Button.new()
	melee_weapon_button.text = "New Melee"
	melee_weapon_button.connect("pressed", func(): _on_forge_new_pressed(Forge.WeaponType.Melee))
	melee_weapon_button.connect("focus_entered", _on_forge_new_focus_entered)
	melee_weapon_button.connect("gui_input", _on_weapon_button_gui_input)
	$WeaponsContainer/VBoxContainer.add_child(melee_weapon_button)
	
	var blink_weapon_button = Button.new()
	blink_weapon_button.text = "New Blink"
	blink_weapon_button.connect("pressed", func(): _on_forge_new_pressed(Forge.WeaponType.Blink))
	blink_weapon_button.connect("focus_entered", _on_forge_new_focus_entered)
	blink_weapon_button.connect("gui_input", _on_weapon_button_gui_input)
	$WeaponsContainer/VBoxContainer.add_child(blink_weapon_button)
		
	var aoe_weapon_button = Button.new()
	aoe_weapon_button.text = "New AOE DOT"
	aoe_weapon_button.connect("pressed", func(): _on_forge_new_pressed(Forge.WeaponType.AoeDot))
	aoe_weapon_button.connect("focus_entered", _on_forge_new_focus_entered)
	aoe_weapon_button.connect("gui_input", _on_weapon_button_gui_input)
	$WeaponsContainer/VBoxContainer.add_child(aoe_weapon_button)
		
	var projectile_weapon_button = Button.new()
	projectile_weapon_button.text = "New Projectile"
	projectile_weapon_button.connect("pressed", func(): _on_forge_new_pressed(Forge.WeaponType.Projectile))
	projectile_weapon_button.connect("focus_entered", _on_forge_new_focus_entered)
	projectile_weapon_button.connect("gui_input", _on_weapon_button_gui_input)
	$WeaponsContainer/VBoxContainer.add_child(projectile_weapon_button)
		
	var explosive_weapon_button = Button.new()
	explosive_weapon_button.text = "New Explosive Projectile"
	explosive_weapon_button.connect("pressed", func(): _on_forge_new_pressed(Forge.WeaponType.ExplosiveProjectile))
	explosive_weapon_button.connect("focus_entered", _on_forge_new_focus_entered)
	explosive_weapon_button.connect("gui_input", _on_weapon_button_gui_input)
	$WeaponsContainer/VBoxContainer.add_child(explosive_weapon_button)
	
	$WeaponsContainer/VBoxContainer.get_child(0).grab_focus()
	
	reset_materials()
	update_current_labels()
	update_available_labels()
	
func reset_materials() -> void:
	current_materials = {
		"a":0,
		"b":0,
		"c":0,
		"d":0,
		"e":0,
	}
	available_materials = player.materials.duplicate()

func update_current_labels() -> void:
	$InventoryContainer/MaterialA/Current.text = str(current_materials.get("a", 0))
	$InventoryContainer/MaterialB/Current.text = str(current_materials.get("b", 0))
	$InventoryContainer/MaterialC/Current.text = str(current_materials.get("c", 0))
	$InventoryContainer/MaterialD/Current.text = str(current_materials.get("d", 0))
	$InventoryContainer/MaterialE/Current.text = str(current_materials.get("e", 0))
	$InventoryContainer/MaterialF/Current.text = str(current_materials.get("f", 0))

func update_available_labels() -> void:
	$InventoryContainer/MaterialA/Available.text = str(available_materials.get("a", 0))
	$InventoryContainer/MaterialB/Available.text = str(available_materials.get("b", 0))
	$InventoryContainer/MaterialC/Available.text = str(available_materials.get("c", 0))
	$InventoryContainer/MaterialD/Available.text = str(available_materials.get("d", 0))
	$InventoryContainer/MaterialE/Available.text = str(available_materials.get("e", 0))
	$InventoryContainer/MaterialF/Available.text = str(available_materials.get("f", 0))

func _on_weapon_button_pressed(is_arm: bool, index: int) -> void:
	selected_weapon_from_arms = is_arm
	selected_weapon_index = index
	new_weapon_type = null
	var weapon = player.arm_weapons[selected_weapon_index] if is_arm else player.inventory_weapons[selected_weapon_index]
	current_materials = weapon.materials.duplicate()
	update_current_labels()
	$InventoryContainer/MaterialA/More.grab_focus()

func _on_weapon_focus_entered(is_arm: bool, index: int) -> void:
	var weapon = player.arm_weapons[index] if is_arm else player.inventory_weapons[index]
	$OldWeaponDetails.populate(weapon)

func _on_weapon_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = false
		self.hide()
	# left bumper to inventory menu
	if event.is_action_pressed("PageLeft"):
		_on_inventory_button_pressed()
	
func _on_forge_new_pressed(type: Forge.WeaponType) -> void:
	new_weapon_type = type
	$InventoryContainer/MaterialA/More.grab_focus()
	
func _on_forge_new_focus_entered() -> void:
	$OldWeaponDetails.populate(null)


func _on_inventory_button_pressed() -> void:
	self.hide()
	var inventory_menu = get_parent().get_node("InventoryMenu")
	inventory_menu.configure(player)
	inventory_menu.show()
		
			
func refresh_new_weapon() -> void:
	var forge = Forge.new() # TODO get this from somewhere

	# update details in $NewWeaponDetails
	if new_weapon_type != null:
		$NewWeaponDetails.populate(forge.create_weapon(new_weapon_type, current_materials))
	else:
		var existing_weapon = player.arm_weapons[selected_weapon_index] if selected_weapon_from_arms else player.inventory_weapons[selected_weapon_index]
		$NewWeaponDetails.populate(forge.create_weapon(existing_weapon.type, current_materials))


func _on_less_pressed(material: String) -> void:
	var current = current_materials.get(material, 0)
	var available = available_materials.get(material, 0)
	if current <= 0:
		pass
	else:
		current_materials.set(material, current - 1)
		available_materials.set(material, available + 1)
		update_current_labels()
		update_available_labels()
		refresh_new_weapon()


func _on_more_pressed(material: String) -> void:
	var current = current_materials.get(material, 0)
	var available = available_materials.get(material, 0)
	if available <= 0:
		pass
	else:
		current_materials.set(material, current + 1)
		available_materials.set(material, available - 1)
		update_current_labels()
		update_available_labels()
		refresh_new_weapon()

func _on_material_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		selected_weapon_from_arms = false
		selected_weapon_index = -1
		new_weapon_type = null
		reset_materials()
		update_available_labels()
		update_current_labels()
		$WeaponsContainer/VBoxContainer.get_child(0).grab_focus()

# TODO don't allow forging with no materials
func _on_forge_button_pressed() -> void:
	var forge = Forge.new() # TODO get this from somewhere
	if new_weapon_type != null:
		var weapon = forge.create_weapon(new_weapon_type, current_materials)
		for i in range(8):
			if player.inventory_weapons[i] == null:
				player.inventory_weapons[i] = weapon
				break
		# TODO what if inventory is full?
		# for now you just lose the stuff, lol
	else:
		var existing_weapon = player.arm_weapons[selected_weapon_index] if selected_weapon_from_arms else player.inventory_weapons[selected_weapon_index]
		var weapon = forge.create_weapon(existing_weapon.type, current_materials)
		if selected_weapon_from_arms:
			player.arm_weapons[selected_weapon_index] = weapon
		else:
			player.inventory_weapons[selected_weapon_index] = weapon
	player.materials = available_materials
	configure(player)


func _on_destroy_button_pressed() -> void:
	for material in current_materials:
		player.materials[material] = player.materials.get(material, 0) + current_materials[material]
	if new_weapon_type == null:
		if selected_weapon_from_arms:
			player.arm_weapons[selected_weapon_index] = null
		else:
			player.inventory_weapons[selected_weapon_index] = null
			var index = selected_weapon_index
			# move non-nulls up the list
			while index < 7 and player.inventory_weapons[index + 1] != null:
				player.inventory_weapons[index] = player.inventory_weapons[index + 1]
				player.inventory_weapons[index + 1] = null
				index += 1

	configure(player)
