class_name Forge
extends Node

enum WeaponType {
	Melee,
	Projectile,
	ExplosiveProjectile,
	Blink,
	AoeDot,
}

# TODO randomize these
var melee_material_mapping = {
	"power": "a",
}
var projectile_material_mapping = {
	"power": "a",
	"spell_range": "b",
	"diameter": "c",
	"projectile_speed": "d",
}
var explosive_projectile_material_mapping = {
	"power": "a",
	"spell_range": "b",
	"diameter": "c",
	"projectile_speed": "d",
	"explosion_diameter": "e",
}
var blink_material_mapping = {
	"spell_range": "a"
}
var aoe_dot_material_mapping = {
	"power": "a",
	"aoe_radius": "b"
}

var sword_scene = preload("res://sword.tscn")
var projectile_scene = preload("res://wand.tscn")
var explosive_projectile_scene = preload("res://explosive_projectile_wand.tscn")
var blink_scene = preload("res://blink_wand.tscn")
var aoe_dot_scene = preload("res://circle_aoe_dot_wand.tscn")

func create_weapon(name: String, weapon_type: WeaponType, materials: Dictionary) -> Node:
	if weapon_type == WeaponType.Melee:
		return create_melee_weapon(name, materials)
	if weapon_type == WeaponType.Projectile:
		return create_projectile_weapon(name, materials)	
	if weapon_type == WeaponType.ExplosiveProjectile:
		return create_explosive_projectile_weapon(name, materials)
	if weapon_type == WeaponType.Blink:
		return create_blink_weapon(name, materials)
	if weapon_type == WeaponType.AoeDot:
		return create_aoe_dot_weapon(name, materials)
	
	# This should be unreachable because all enums are covered above
	return null
		

func create_melee_weapon(name: String, materials: Dictionary) -> Sword:
	var power_material = materials.get(melee_material_mapping.get("power"), 0)
	var power_level = calculate_level(power_material)
	var power = power_level * 10
	
	var display_name = name if name else "Sword"
	var mana_cost = 0
	var speed_scale = 1.0 # TODO
	# TODO color?
	return sword_scene.instantiate().configure(materials, {
		"display_name": display_name,
		"power": power,
		"mana_cost": mana_cost,
		"speed_scale": speed_scale,
	})


func create_projectile_weapon(name: String, materials: Dictionary) -> Wand:
	var power = calculate_level(materials.get(projectile_material_mapping.get("power"), 0)) * 20
	var mana_cost = calculate_level(materials.values().reduce(func (a, b): return a + b, 0)) * 10
	var display_name = name if name else "Projectile"
	var speed_scale = 1.0 # TODO
	var spell_range = calculate_level(materials.get(projectile_material_mapping.get("spell_range"), 0)) * 40 + 200
	var projectile_speed = calculate_level(materials.get(projectile_material_mapping.get("projectile_speed"), 0)) * 40 + 200
	var diameter = calculate_level(materials.get(projectile_material_mapping.get("diameter"), 0)) * 10 + 40
	# TODO color?
	return projectile_scene.instantiate().configure(materials, {
		"power": power,
		"mana_cost": mana_cost,
		"display_name": display_name,
		"speed_scale": speed_scale,
		"spell_range": spell_range,
		"projectile_speed": projectile_speed,
		"diameter": diameter,
	})
	

func create_explosive_projectile_weapon(name: String, materials: Dictionary) -> ExplosiveProjectileWand:
	var power = calculate_level(materials.get(explosive_projectile_material_mapping.get("power"), 0)) * 20
	var mana_cost = calculate_level(materials.values().reduce(func (a, b): return a + b, 0)) * 10
	var display_name = name if name else "Explosive Projectile"
	var speed_scale = 1.0 # TODO
	var spell_range = calculate_level(materials.get(explosive_projectile_material_mapping.get("spell_range"), 0)) * 40 + 200
	var projectile_speed = calculate_level(materials.get(explosive_projectile_material_mapping.get("projectile_speed"), 0)) * 100
	var diameter = calculate_level(materials.get(explosive_projectile_material_mapping.get("diameter"), 0)) * 10 + 40
	var explosion_diameter = calculate_level(materials.get(explosive_projectile_material_mapping.get("explosion_diameter"), 0)) * 20 + 30
	# TODO color?
	return explosive_projectile_scene.instantiate().configure(materials, {
		"power": power,
		"mana_cost": mana_cost,
		"display_name": display_name,
		"speed_scale": speed_scale,
		"spell_range": spell_range,
		"projectile_speed": projectile_speed,
		"diameter": diameter,
	})
	

func create_blink_weapon(name: String, materials: Dictionary) -> BlinkWand:
	var spell_range = calculate_level(materials.get(blink_material_mapping.get("spell_range"), 0)) * 50
	var mana_cost = calculate_level(materials.values().reduce(func (a, b): return a + b, 0)) * 10
	var speed_scale = 2.0 # TODO
	var display_name = name if name else "Blink"
	# TODO color?
	return blink_scene.instantiate().configure(materials, {
		"spell_range": spell_range,
		"mana_cost": mana_cost,
		"display_name": display_name,
		"speed_scale": speed_scale,
	})


func create_aoe_dot_weapon(name: String, materials: Dictionary) -> CircleAoeDotWand:
	var display_name = name if name else "Circle AEO DOT"
	var power = calculate_level(materials.get(aoe_dot_material_mapping.get("power"), 0)) * 5
	var mana_cost = 0
	var mana_per_second = calculate_level(materials.values().reduce(func (a, b): return a + b, 0)) * 2
	var aoe_radius = calculate_level(materials.get(aoe_dot_material_mapping.get("aoe_radius"), 0)) * 20 + 30
	# TODO color?
	return aoe_dot_scene.instantiate().configure(materials, {
		"display_name": display_name,
		"power": power,
		"mana_cost": mana_cost,
		"mana_per_second": mana_per_second,
		"aoe_radius": aoe_radius,
	})

func calculate_level(amount: int) -> int:
	var level = 0
	while amount != 0:
		level +=1
		amount = amount / 2
	return level
