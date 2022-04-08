extends Node2D

const OFFSCREEN_BUFFER_PIXELS := 20.0
const MIN_PLATFORM_Y_CLOSENESS := 50.0

export(int) var level_seed := 0

export(float) var pixels_per_sec := 100.0

export(float) var ceiling_level := 0.0
export(float) var ground_level := 340.0

export(float) var player_height := 64.0

export(NodePath) var _level_path := NodePath()
export(NodePath) var _player_path := NodePath()

export(float) var platform_min_length := 50.0
export(float) var platform_max_length := 300.0

export(int, 0, 10_000) var platform_spawn_min_msec := 1_000
export(int, 0, 10_000) var platform_spawn_max_msec := 4_000

export(int, 0, 100) var item_spawn_probability := 50
export(int, 0, 100) var item_spawn_on_platform := 50

onready var _level := NodE.get_node_with_error(self, _level_path, Node2D) as Node2D
onready var _player := NodE.get_node_with_error(self, _player_path, Node2D) as Node2D

onready var _platform_spawn_timer := NodE.add_child(self, TimEr.one_shot(1.0, self, '_on_platform_spawn')) as Timer

onready var _random := RandomNumberGenerator.new()

var _possible_spawn_items := []

func _ready() -> void:
	_random.seed = level_seed
	
	_last_y_player_hit = ground_level
	
	var jump := NodE.get_child(_player, InfiniteRunnerJump) as InfiniteRunnerJump
	assert(jump)
	
	for item in NodE.get_children(self, PickUpItem):
		NodE.set_owner_recursive(item, item)
		var packed_scene := PackedScene.new()
		item.visible = true
		packed_scene.pack(item)
		item.visible = false
		_possible_spawn_items.push_back(packed_scene)
	
	jump.connect('floor_hit', self, '_player_on_floor_hit')
	

func start() -> void:
	_on_platform_spawn()

func stop() -> void:
	_platform_spawn_timer.stop()

func _player_on_floor_hit() -> void:
	var collision_extents := NodE.get_child(_player, CollisionExtents) as CollisionExtents
	var rect := collision_extents.get_as_global_rect()
	_last_y_player_hit = rect.position.y + rect.size.y

var _last_y_player_hit := 0.0
var _last_y_platform_spawned := INF
func _on_platform_spawn() -> void:
	var next_spawn_sec := (_random.randf_range(platform_spawn_min_msec, platform_spawn_max_msec) / 1000.0) as float
	
	_platform_spawn_timer.start(next_spawn_sec)
	
	var y_top_spawn := ceiling_level + player_height
	var y_bottom_spawn := ground_level
	
	var max_y := max(y_top_spawn, _last_y_player_hit - _get_player_jump_height())
	
	var platform := _add_platform(y_bottom_spawn, max_y)
	
	_add_item(platform, y_bottom_spawn, max_y)

func _add_item(platform: LinePlatform, bottom_y: float, top_y: float) -> void:
	var is_item_spawn := _random.randi_range(0, 100) < item_spawn_probability
	if not is_item_spawn:
		return
	
	var is_on_platform := _random.randi_range(0, 100) < item_spawn_on_platform
	
	var item_scene := _possible_spawn_items[_random.randi() % _possible_spawn_items.size()] as PackedScene
	var item := item_scene.instance()
	
	var extents := NodE.get_child(item, CollisionExtents) as CollisionExtents
	
	item.position.x = _random.randf_range(0, platform.length)
	
	platform.add_child(item)
	
	if is_on_platform:
		item.position.y -= extents.value.y
	else:
		top_y -= _get_player_jump_height()
		var spawn_y := _random.randf_range(top_y, bottom_y)
		
		for i in 20:
			if abs(spawn_y - platform.global_position.y) < extents.value.y:
				continue
			spawn_y = _random.randf_range(top_y, bottom_y)
		
		item.position.y = platform.to_local(Vector2(0, spawn_y)).y

func _add_platform(bottom_y: float, top_y: float) -> LinePlatform:
	var y_spawn := _random.randf_range(top_y, bottom_y)
	for i in 20:
		if abs(y_spawn - _last_y_platform_spawned) > MIN_PLATFORM_Y_CLOSENESS:
			break
		y_spawn = _random.randf_range(top_y, bottom_y)
	
	_last_y_platform_spawned = y_spawn
	
	var offscreen := get_tree().root.size.x + OFFSCREEN_BUFFER_PIXELS
	
	var position := _level.to_local(Vector2(offscreen, y_spawn))
	
	var platform := LinePlatform.new()
	platform.height = 25.0
	platform.length = _random.randf_range(platform_min_length, platform_max_length)
	platform.position = position
	
	_level.add_child(platform)
	_add_free_conditions(platform)
	_add_scroll_move(platform)
	
	return platform

func _add_scroll_move(moving_thing: Node2D) -> void:
	var scroll_move := ScrollMove.new()
	scroll_move.speed_pixels = pixels_per_sec
	scroll_move.direction = Vector2.LEFT
	
	moving_thing.add_child(scroll_move)

func _add_free_conditions(platform: LinePlatform) -> void:
	var visibility_notifier := VisibilityNotifier2D.new()
	visibility_notifier.connect('screen_exited', self, '_on_platform_screen_exited', [platform])
	visibility_notifier.position.x = platform.length / 2.0
	visibility_notifier.rect = Rect2(-platform.length / 2.0, -1, platform.length, 2)
	
	platform.add_child(visibility_notifier)

func _on_platform_screen_exited(platform: LinePlatform) -> void:
	platform.queue_free()

func _get_player_jump_height() -> float:
	var jump := NodE.get_child(_player, InfiniteRunnerJump) as InfiniteRunnerJump
	return jump.jump_height * jump.units
