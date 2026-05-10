class_name EnemyManager extends Node2D

@onready var path: Path2D = $Path2D
@onready var follow: PathFollow2D = $Path2D/PathFollow2D
@onready var wave_timer: Timer = $WaveTimer

@onready var lumberjack_timer: EnemyTimer = $LumberjackTimer
@onready var thief_timer: EnemyTimer = $ThiefTimer
@onready var peasent_timer: EnemyTimer = $PeasentTimer
@onready var digger_timer: EnemyTimer = $DiggerTimer

@onready var timers: Dictionary = {
	"lumberjack": lumberjack_timer,
	"thief": thief_timer,
	"peasant": peasent_timer,
	"digger": digger_timer
}

var lumberjack: PackedScene = preload("res://src/scenes/enemies/lumberjack.tscn")
var thief: PackedScene = preload("res://src/scenes/enemies/thief.tscn")
var peasant: PackedScene = preload("res://src/scenes/enemies/peasent.tscn")
var digger: PackedScene = preload("res://src/scenes/enemies/digger.tscn")

@onready var enemy_types: Dictionary = {
	"lumberjack": lumberjack,
	"thief": thief,
	"peasant": peasant,
	"digger": digger
}

# Wave data
var wave_data: Dictionary = {
	1: {"wave_time": 60, "data": [
		{"enemy": "lumberjack", "count": 10, "spawn_rate": 10}
	]},
	2: {"wave_time": 60, "data": [
		{"enemy": "lumberjack", "count": 10, "spawn_rate": 10},
		{"enemy": "thief", "count": 2, "spawn_rate": 4}
	]},
	3: {"wave_time": 60, "data": [
		{"enemy": "lumberjack", "count": 15, "spawn_rate": 10},
		{"enemy": "thief", "count": 2, "spawn_rate": 4}
	]},
	4: {"wave_time": 60, "data": [
		{"enemy": "lumberjack", "count": 15, "spawn_rate": 10},
		{"enemy": "thief", "count": 2, "spawn_rate": 4},
		{"enemy": "peasant", "count": 5, "spawn_rate": 5},
	]},
	5: {"wave_time": 60, "data": [
		{"enemy": "lumberjack", "count": 15, "spawn_rate": 10},
		{"enemy": "thief", "count": 3, "spawn_rate": 4},
		{"enemy": "peasant", "count": 7, "spawn_rate": 5},
	]},
	6: {"wave_time": 60, "data": [
		{"enemy": "lumberjack", "count": 10, "spawn_rate": 5},
		{"enemy": "thief", "count": 2, "spawn_rate": 4},
		{"enemy": "peasant", "count": 5, "spawn_rate": 5},
		{"enemy": "digger", "count": 1, "spawn_rate": 181},
	]},
	7: {"wave_time": 60, "data": [
		{"enemy": "lumberjack", "count": 50, "spawn_rate": 31},
		{"enemy": "thief", "count": 2, "spawn_rate": 4}
	]},
	8: {"wave_time": 60, "data": [
		{"enemy": "lumberjack", "count": 10, "spawn_rate": 5},
		{"enemy": "thief", "count": 2, "spawn_rate": 4},
		{"enemy": "peasant", "count": 10, "spawn_rate": 5},
		{"enemy": "digger", "count": 1, "spawn_rate": 181},
	]},
	9: {"wave_time": 60, "data": [
		{"enemy": "lumberjack", "count": 5, "spawn_rate": 5},
		{"enemy": "thief", "count": 2, "spawn_rate": 4},
		{"enemy": "peasant", "count": 20, "spawn_rate": 5},
		{"enemy": "digger", "count": 1, "spawn_rate": 181},
	]},
	10: {"wave_time": 60, "data": [
		{"enemy": "lumberjack", "count": 10, "spawn_rate": 5},
		{"enemy": "thief", "count": 2, "spawn_rate": 4},
		{"enemy": "peasant", "count": 20, "spawn_rate": 5},
		{"enemy": "digger", "count": 2, "spawn_rate": 181},
	]},
	11: {"wave_time": 60, "data": [
		{"enemy": "lumberjack", "count": 30, "spawn_rate": 5},
		{"enemy": "thief", "count": 6, "spawn_rate": 4},
		{"enemy": "peasant", "count": 15, "spawn_rate": 5},
		{"enemy": "digger", "count": 4, "spawn_rate": 181},
	]},
	12: {"wave_time": 60, "data": [
		{"enemy": "thief", "count": 40, "spawn_rate": 20},
	]},
	13: {"wave_time": 60, "data": [
		{"enemy": "lumberjack", "count": 10, "spawn_rate": 5},
		{"enemy": "thief", "count": 4, "spawn_rate": 4},
		{"enemy": "peasant", "count": 20, "spawn_rate": 5},
		{"enemy": "digger", "count": 10, "spawn_rate": 181},
	]},
	14: {"wave_time": 60, "data": [
		{"enemy": "lumberjack", "count": 10, "spawn_rate": 5},
		{"enemy": "thief", "count": 4, "spawn_rate": 4},
		{"enemy": "peasant", "count": 30, "spawn_rate": 5},
		{"enemy": "digger", "count": 20, "spawn_rate": 181},
	]},
}


var current_wave: int = 1

func _ready() -> void:
	wave_timer.connect("timeout", self._on_wave_timer_timeout)

	# Create reverse mapping and connect timers
	for enemy_type in timers.keys():
		var timer: EnemyTimer = timers[enemy_type]
		timer.spawn_timeout.connect(_on_enemy_timer_timeout)
	
func start_this_shit():
	start_wave()
	current_wave += 1

func pick_random_position() -> Vector2:
	var found: bool = false
	var camera_pos: Vector2 = Global.player.camera.global_position
	var viewrect: Rect2 = get_viewport_rect()
	var rect: Rect2 = Rect2(camera_pos.x - viewrect.size.x / 2, camera_pos.y - viewrect.size.y / 2, viewrect.size.x + 100, viewrect.size.y + 100)
	while not found:
		follow.progress_ratio = randf()
		found = not rect.has_point(follow.global_position)
	return follow.global_position

func spawn_enemy(enemy_type: PackedScene) -> void:
	var new_enemy_node: Node2D = enemy_type.instantiate()
	new_enemy_node.global_position = pick_random_position()
	add_child(new_enemy_node)

func spawn_enemies(enemy_type: PackedScene, amount: int) -> void:
	for i in range(amount):
		spawn_enemy(enemy_type)

func _on_wave_timer_timeout() -> void:
	if wave_data.has(current_wave):
		start_wave()
		current_wave += 1
	else:
		wave_timer.stop()  # Stop the game if all waves are completed

func start_wave() -> void:
	wave_timer.start(wave_data[self.current_wave]["wave_time"])  # Example: Each wave lasts 20 seconds
	for enemy_type in timers.keys():
		var timer: EnemyTimer = timers[enemy_type]
		timer.stop()

	# Configure timers for the current wave
	for enemy_data in wave_data[self.current_wave].get("data", []):
		var enemy_type = enemy_data["enemy"]
		var spawn_rate = enemy_data["spawn_rate"]
		var spawn_count = enemy_data["count"]
		
		var timer: EnemyTimer = timers[enemy_type]
		timer.wait_time = spawn_rate
		timer.spawn_count = spawn_count
		timer.my_type = enemy_type
		_on_enemy_timer_timeout(enemy_type, spawn_count)
		
		timer.start()

func _on_enemy_timer_timeout(enemy_type: String, amount) -> void:
	spawn_enemies(enemy_types[enemy_type], amount)
