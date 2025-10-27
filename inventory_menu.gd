extends CanvasLayer

var player: Player = null

var selected_arm: int = -1

func _ready() -> void:
	$ArmsContainer/Arm0/Button.connect("pressed", func(): _on_arm_button_pressed(0))
	$ArmsContainer/Arm0/Button.connect("focus_entered", func(): _on_arm_focus_entered(0))
	$ArmsContainer/Arm0/Button.connect("gui_input", _on_arm_button_gui_input)
	
	$ArmsContainer/Arm1/Button.connect("pressed", func(): _on_arm_button_pressed(1))
	$ArmsContainer/Arm1/Button.connect("focus_entered", func(): _on_arm_focus_entered(1))
	$ArmsContainer/Arm1/Button.connect("gui_input", _on_arm_button_gui_input)
	
	$ArmsContainer/Arm2/Button.connect("pressed", func(): _on_arm_button_pressed(2))
	$ArmsContainer/Arm2/Button.connect("focus_entered", func(): _on_arm_focus_entered(2))
	$ArmsContainer/Arm2/Button.connect("gui_input", _on_arm_button_gui_input)
	
	$ArmsContainer/Arm3/Button.connect("pressed", func(): _on_arm_button_pressed(3))
	$ArmsContainer/Arm3/Button.connect("focus_entered", func(): _on_arm_focus_entered(3))
	$ArmsContainer/Arm3/Button.connect("gui_input", _on_arm_button_gui_input)
	
	$ArmsContainer/Arm4/Button.connect("pressed", func(): _on_arm_button_pressed(4))
	$ArmsContainer/Arm4/Button.connect("focus_entered", func(): _on_arm_focus_entered(4))
	$ArmsContainer/Arm4/Button.connect("gui_input", _on_arm_button_gui_input)
	
	$ArmsContainer/Arm5/Button.connect("pressed", func(): _on_arm_button_pressed(5))
	$ArmsContainer/Arm5/Button.connect("focus_entered", func(): _on_arm_focus_entered(5))
	$ArmsContainer/Arm5/Button.connect("gui_input", _on_arm_button_gui_input)
	
	$ArmsContainer/Arm6/Button.connect("pressed", func(): _on_arm_button_pressed(6))
	$ArmsContainer/Arm6/Button.connect("focus_entered", func(): _on_arm_focus_entered(6))
	$ArmsContainer/Arm6/Button.connect("gui_input", _on_arm_button_gui_input)
	
	$ArmsContainer/Arm7/Button.connect("pressed", func(): _on_arm_button_pressed(7))
	$ArmsContainer/Arm7/Button.connect("focus_entered", func(): _on_arm_focus_entered(7))
	$ArmsContainer/Arm7/Button.connect("gui_input", _on_arm_button_gui_input)
	

	$InventoryContainer/Item0.connect("pressed", func(): _on_item_button_pressed(0))
	$InventoryContainer/Item0.connect("focus_entered", func(): _on_item_button_focused(0))
	$InventoryContainer/Item0.connect("gui_input", _on_item_gui_input)
	
	$InventoryContainer/Item1.connect("pressed", func(): _on_item_button_pressed(1))
	$InventoryContainer/Item1.connect("focus_entered", func(): _on_item_button_focused(1))
	$InventoryContainer/Item1.connect("gui_input", _on_item_gui_input)
	
	$InventoryContainer/Item2.connect("pressed", func(): _on_item_button_pressed(2))
	$InventoryContainer/Item2.connect("focus_entered", func(): _on_item_button_focused(2))
	$InventoryContainer/Item2.connect("gui_input", _on_item_gui_input)
	
	$InventoryContainer/Item3.connect("pressed", func(): _on_item_button_pressed(3))
	$InventoryContainer/Item3.connect("focus_entered", func(): _on_item_button_focused(3))
	$InventoryContainer/Item3.connect("gui_input", _on_item_gui_input)
	
	$InventoryContainer/Item4.connect("pressed", func(): _on_item_button_pressed(4))
	$InventoryContainer/Item4.connect("focus_entered", func(): _on_item_button_focused(4))
	$InventoryContainer/Item4.connect("gui_input", _on_item_gui_input)
	
	$InventoryContainer/Item5.connect("pressed", func(): _on_item_button_pressed(5))
	$InventoryContainer/Item5.connect("focus_entered", func(): _on_item_button_focused(5))
	$InventoryContainer/Item5.connect("gui_input", _on_item_gui_input)
	
	$InventoryContainer/Item6.connect("pressed", func(): _on_item_button_pressed(6))
	$InventoryContainer/Item6.connect("focus_entered", func(): _on_item_button_focused(6))
	$InventoryContainer/Item6.connect("gui_input", _on_item_gui_input)
	
	$InventoryContainer/Item7.connect("pressed", func(): _on_item_button_pressed(7))
	$InventoryContainer/Item7.connect("focus_entered", func(): _on_item_button_focused(7))
	$InventoryContainer/Item7.connect("gui_input", _on_item_gui_input)
	

func configure(player: Player) -> void:
	self.player = player
	reconfigure()

func reconfigure() -> void:
	$ArmsContainer/Arm0/Button.text = player.arm_weapons[0].display_name if player.arm_weapons[0] else "<Empty>"
	$ArmsContainer/Arm1/Button.text = player.arm_weapons[1].display_name if player.arm_weapons[1] else "<Empty>"
	$ArmsContainer/Arm2/Button.text = player.arm_weapons[2].display_name if player.arm_weapons[2] else "<Empty>"
	$ArmsContainer/Arm3/Button.text = player.arm_weapons[3].display_name if player.arm_weapons[3] else "<Empty>"
	$ArmsContainer/Arm4/Button.text = player.arm_weapons[4].display_name if player.arm_weapons[4] else "<Empty>"
	$ArmsContainer/Arm5/Button.text = player.arm_weapons[5].display_name if player.arm_weapons[5] else "<Empty>"
	$ArmsContainer/Arm6/Button.text = player.arm_weapons[6].display_name if player.arm_weapons[6] else "<Empty>"
	$ArmsContainer/Arm7/Button.text = player.arm_weapons[7].display_name if player.arm_weapons[7] else "<Empty>"
	
	if player.inventory_weapons[0]:
		$InventoryContainer/Item0.text = player.inventory_weapons[0].display_name
		$InventoryContainer/Item0.show()
	else:
		$InventoryContainer/Item0.hide()
		$InventoryContainer/Item0.text = "Empty"
	
	if player.inventory_weapons[1]:
		$InventoryContainer/Item1.text = player.inventory_weapons[1].display_name
		$InventoryContainer/Item1.show()
	else:
		$InventoryContainer/Item1.hide()
		$InventoryContainer/Item1.text = "Empty"
	
	if player.inventory_weapons[2]:
		$InventoryContainer/Item2.text = player.inventory_weapons[2].display_name
		$InventoryContainer/Item2.show()
	else:
		$InventoryContainer/Item2.hide()
		$InventoryContainer/Item2.text = "Empty"
	
	if player.inventory_weapons[3]:
		$InventoryContainer/Item3.text = player.inventory_weapons[3].display_name
		$InventoryContainer/Item3.show()
	else:
		$InventoryContainer/Item3.hide()
		$InventoryContainer/Item3.text = "Empty"
	
	if player.inventory_weapons[4]:
		$InventoryContainer/Item4.text = player.inventory_weapons[4].display_name
		$InventoryContainer/Item4.show()
	else:
		$InventoryContainer/Item4.hide()
		$InventoryContainer/Item4.text = "Empty"
	
	if player.inventory_weapons[5]:
		$InventoryContainer/Item5.text = player.inventory_weapons[5].display_name
		$InventoryContainer/Item5.show()
	else:
		$InventoryContainer/Item5.hide()
		$InventoryContainer/Item5.text = "Empty"
	
	if player.inventory_weapons[6]:
		$InventoryContainer/Item6.text = player.inventory_weapons[6].display_name
		$InventoryContainer/Item6.show()
	else:
		$InventoryContainer/Item6.hide()
		$InventoryContainer/Item6.text = "Empty"
	
	if player.inventory_weapons[7]:
		$InventoryContainer/Item7.text = player.inventory_weapons[7].display_name
		$InventoryContainer/Item7.show()
	else:
		$InventoryContainer/Item7.hide()
		$InventoryContainer/Item7.text = "Empty"
		
	$ArmsContainer/Arm0/Button.grab_focus()


func _on_arm_button_pressed(index: int) -> void:
	selected_arm = index
	$InventoryContainer/Empty.grab_focus()

func _on_arm_focus_entered(index: int) -> void:
	$ArmWeaponDetails.populate(player.arm_weapons[index])

func _on_item_button_pressed(index: int) -> void:
	if player.arm_weapons[selected_arm] != null:
		var unequipped = player.arm_weapons[selected_arm]
		player.set_arm_weapon(selected_arm, player.inventory_weapons[index])
		player.inventory_weapons[index] = unequipped
	else:
		player.set_arm_weapon(selected_arm, player.inventory_weapons[index])
		player.inventory_weapons[index] = null
		# move non-nulls up the list
		while index < 8 and player.inventory_weapons[index + 1] != null:
			player.inventory_weapons[index] = player.inventory_weapons[index + 1]
			player.inventory_weapons[index + 1] = null
			index += 1

	reconfigure()
	$InventoryWeaponDetails.clear()
	$ArmsContainer/Arm0/Button.grab_focus()

func _on_empty_pressed() -> void:
	if player.arm_weapons[selected_arm] != null:
		var unequipped = player.arm_weapons[selected_arm]
		player.set_arm_weapon(selected_arm, null)
		for i in range(8):
			if player.inventory_weapons[i] == null:
				player.inventory_weapons[i] = unequipped
				break
			# TODO what if inventory is full?
		reconfigure()
	else: # arm is already empty
		pass
	$InventoryWeaponDetails.clear()
	$ArmsContainer/Arm0/Button.grab_focus()

func _on_item_button_focused(index: int) -> void:
	$InventoryWeaponDetails.populate(player.inventory_weapons[index])
	
func _on_item_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_left"):
		selected_arm = -1
		$InventoryWeaponDetails.clear()
		# TODO focus previously selected arm?
		$ArmsContainer/Arm0/Button.grab_focus()

func _on_arm_button_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = false
		self.hide()
	if event.is_action_pressed("PageRight"):
		_on_forge_button_pressed()

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	self.hide()


func _on_forge_button_pressed() -> void:
	self.hide()
	var forge_menu = get_parent().get_node("ForgeMenu")
	forge_menu.reconfigure()
	forge_menu.show()
