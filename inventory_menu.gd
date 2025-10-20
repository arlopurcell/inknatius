class_name InventoryMenu
extends CanvasLayer

var player: Player = null

var selected_arm: int = -1

func configure(player: Player) -> void:
	self.player = player

func _on_arm_button_pressed(index: int) -> void:
	selected_arm = index
	print("arm button pressed")
	$InventoryContainer/Item0.grab_focus()

func _on_arm_focus_entered(index: int) -> void:
	print("arm focused")
	$ArmWeaponDetails.populate(player.arm_weapons[index])
	
func _on_arm0_button_pressed() -> void:
	print("arm0 button press")
	_on_arm_button_pressed(0)

func _on_arm0_focus_entered() -> void:
	_on_arm_focus_entered(0)


func _on_arms_container_gui_input(event: InputEvent) -> void:
	print(event)


func _on_arm1_button_pressed() -> void:
	_on_arm_button_pressed(1)


func _on_arm1_focus_entered() -> void:
	_on_arm_focus_entered(1)


func _on_item0_button_pressed() -> void:
	print("item button pressed")
	pass # Replace with function body.


func _on_button_pressed() -> void:
	print("stupid test button pressed")
