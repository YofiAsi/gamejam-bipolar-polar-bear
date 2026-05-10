extends Node

signal gun_shot_signal
signal xp_changed(level: int, value: int, max_xp: int)
signal level_up(level: int)
signal gained_powerup
signal first_time_big_signal
signal first_time_small_signal

enum State {
	BIG,
	SMALL
}

var player: Player
var xp_spawner: XpSpawner
var game_root: GameRoot
var show_bear_text: bool = true:
	set(value):
		show_bear_text = value
		if not value and player:
			player.text_box.hide()
			

const UPGRADES: Dictionary = {
	"ATKSPD": 1,
	"MAX_HP": 1,
	"HEALTH_REG": 1,
	"DMG": 1,
	"RANGE": 1,
	"MAGNET_RADIUS": 1,
	"MVM_SPEED": 1,
}

var curr_upgrades: Dictionary = UPGRADES.duplicate(true)

var won: bool = false

func reset_game() -> void:
	curr_upgrades = UPGRADES.duplicate(true)
	won = false

func start_game() -> void:
	if not SceneManager.is_transitioning:
		SceneManager.change_scene(
			"res://src/scenes/game_root/game_root.tscn", {
				"pattern_enter": "squares",
				"pattern_leave": "squares",
			}
		)

func tutorial() -> void:
	await get_tree().create_timer(2).timeout

	self.show_player_first_text()
	PolarTimer.start(5)
	await get_tree().create_timer(2).timeout
	
	self.game_root.main_game.hud.blink_polar_prog()

func show_player_first_text() -> void:
	player.text_box.show_first()
