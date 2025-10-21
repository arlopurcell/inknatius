class_name Level
extends Node2D

const level_width = 100
const level_height = 100

const room_count_min = 3
const room_count_max = 6

const room_size_min = 8
const room_size_max = 20

const corridor_width = 6

const enemies_per_room_min = 0
const enemies_per_room_max = 3

const tile_size = 32

enum TileType { FLOOR, WALL, EDGE }

static func new_level(new_depth: int, old_player: Player) -> Level:
	var level_scene = load("res://level.tscn")
	var mob_scene = load("res://mob.tscn")
	var level: Level = level_scene.instantiate()
	level.depth = new_depth
	
	var tile_arr = [];
	# first make everything a wall
	for x in range(level_width):
		var tile_column = []
		for y in range(level_height):
			tile_column.append(TileType.WALL)
		tile_arr.append(tile_column);
	
	var rng = RandomNumberGenerator.new()
	
	var last_room_center_x = null
	var last_room_center_y = null
	# now add some rooms
	for i in range(rng.randi_range(room_count_min, room_count_max)):
		var room_x = rng.randi_range(1, level_width - 1)
		var room_y = rng.randi_range(1, level_height - 1)
		
		var room_width = rng.randi_range(room_size_min, room_size_max)
		var room_height = rng.randi_range(room_size_min, room_size_max)
		
		# keep rooms inside level bounds
		if room_x + room_width >= level_width:
			room_x = room_x - room_width
		if room_y + room_height >= level_height:
			room_y = room_y - room_height
		
		for x in range(room_x, room_x + room_width):
			for y in range(room_y, room_y + room_height):
				tile_arr[x][y] = TileType.FLOOR
		
		var room_center_x = room_x + (room_width / 2)
		var room_center_y = room_y + (room_height / 2)
		if last_room_center_x != null:
			# make a corridor from the last room
			for x in range(min(room_center_x, last_room_center_x), max(room_center_x, last_room_center_x)):
				for y in range(room_center_y - corridor_width / 2, room_center_y + corridor_width / 2):
					tile_arr[x][y] = TileType.FLOOR
				
			for y in range(min(room_center_y, last_room_center_y), max(room_center_y, last_room_center_y)):
				for x in range(last_room_center_x - corridor_width / 2, last_room_center_x + corridor_width / 2):
					tile_arr[x][y] = TileType.FLOOR
			
		last_room_center_x = room_center_x
		last_room_center_y = room_center_y
		
		if i == 0:
			# put the player in the middle of the first room
			var player: Player = level.get_child(1)
			if old_player != null:
				player.current_health = old_player.current_health
				player.health_changed.emit()
			player.position = Vector2(room_center_x * tile_size as float, room_center_y * tile_size as float)
		else:
			# add some enemies to other rooms
			for j in range(enemies_per_room_min, enemies_per_room_max):
				var mob: Mob = mob_scene.instantiate()
				var mob_x = rng.randi_range(room_x, room_x + room_width)
				var mob_y = rng.randi_range(room_y, room_y + room_height)
				mob.position = Vector2(mob_x * tile_size as float, mob_y * tile_size as float)
				level.add_child(mob)
				level.enemy_count += 1
				mob.died.connect(level._on_mob_died)
				
	# now make edges
	for x in range(level_width):
		for y in range(level_height):
			if tile_arr[x][y] == TileType.FLOOR:
				if x == 0 || y == 0 || x == level_width - 1 || y == level_height - 1:
					tile_arr[x][y] = TileType.EDGE
				elif tile_arr[x-1][y] == TileType.WALL or tile_arr[x+1][y] == TileType.WALL or tile_arr[x][y-1] == TileType.WALL or tile_arr[x][y+1] == TileType.WALL or tile_arr[x-1][y-1] == TileType.WALL or tile_arr[x+1][y-1] == TileType.WALL or tile_arr[x-1][y+1] == TileType.WALL or tile_arr[x+1][y+1] == TileType.WALL:
					tile_arr[x][y] = TileType.EDGE
	
	var tiles: TileMapLayer = level.get_child(0)
	var source_id = tiles.tile_set.get_source_id(0)
	var wall_coord = Vector2i(0, 0)
	var floor_coord = Vector2i(1, 0)
	var edge_coord = Vector2i(2, 0)
	
	for x in range(level_width):
		for y in range(level_height):
			var tile_coord
			if tile_arr[x][y] == TileType.FLOOR:
				tile_coord = floor_coord
			elif tile_arr[x][y] == TileType.WALL:
				tile_coord = wall_coord
			else:
				tile_coord = edge_coord
			tiles.set_cell(Vector2i(x, y), source_id, tile_coord)
	
	return level

var depth = 1
var enemy_count = 0
var is_on_exit_portal = false

func _ready() -> void:
	$HUD/LevelNumberLabel.text = "Level %d" % depth
	_on_player_health_changed()
	_on_player_mana_changed()

func _process(_delta: float) -> void:
	#if Input.is_action_just_pressed("spawn_enemy"):
	#	var mob = mob_scene.instantiate()
	#	add_child(mob)
	if Input.is_action_just_pressed("Pause"):
		get_tree().paused = true
		$PauseMenu.show()
		$PauseMenu/CenterContainer/VBoxContainer/Resume.grab_focus()
	if Input.is_action_just_pressed("interact"):
		if is_on_exit_portal:
			var next_level = Level.new_level(depth + 1, $Player)

			var tree = get_tree()
			var cur_scene = tree.get_current_scene()
			tree.get_root().add_child(next_level)
			tree.get_root().remove_child(cur_scene)
			tree.set_current_scene(next_level)
	if Input.is_action_just_pressed("inventory"):
		get_tree().paused = true
		$InventoryMenu.configure($Player)
		$InventoryMenu.show()
		$InventoryMenu/ArmsContainer/Arm0/Button.grab_focus()

func _on_mob_died(location: Vector2) -> void:
	enemy_count -= 1
	if enemy_count == 0:
		$ExitPortal.global_position = location
		$ExitPortal/AnimationPlayer.play("open")

func _on_player_health_changed() -> void:
	$HUD/HealthBar.value = ($Player.current_health as float / $Player.max_health as float) * 100.0
	$HUD/HealthText.text = str($Player.current_health) + "/" + str($Player.max_health)

func _on_player_mana_changed() -> void:
	$HUD/ManaBar.value = ($Player.current_mana as float / $Player.max_mana as float) * 100.0
	$HUD/ManaText.text = str($Player.current_mana) + "/" + str($Player.max_mana)


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
	$DeathMenu/CenterContainer/VBoxContainer/ExitToMenu.grab_focus()
	get_tree().paused = true


func _on_exit_portal_body_entered(body: Node2D) -> void:
	if body == $Player:
		is_on_exit_portal = true


func _on_exit_portal_body_exited(body: Node2D) -> void:
	if body == $Player:
		is_on_exit_portal = false
