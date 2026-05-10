class_name GameRoot extends Node2D

@onready var main_game: GameManager = $GameManager
@onready var pause_menu: CanvasLayer = $PauseMenu
@onready var powerup_menu: PowerupMenu = $PowerupMenu
@onready var big_tutorial: Tutoraial = $TutorialBig
@onready var small_tutorial: Tutoraial = $TutorialSmall
@onready var credits: Credits = $Credits

var is_paused: bool = false  # Track pause state
var on_powerup_menu: bool = false
var showing_big_tutorial: bool = false
var showing_small_tutorial: bool = false
var tutorial_ended: bool = false
var on_credits: bool = false

func _ready():
	pause_menu.hide()
	Global.game_root = self
	Global.first_time_big_signal.connect(show_big_tutorial)
	Global.first_time_small_signal.connect(show_small_tutorial)
	#Global.reset_game()

func _input(event):
	if on_powerup_menu or on_credits:
		return
	if event.is_action_pressed("next_tutorial") and showing_big_tutorial:
		Global.game_root.main_game.winning_timer.show()
		Global.game_root.main_game.winning_timer.start()
		hide_big_tutorial()
		return
	if event.is_action_pressed("next_tutorial") and showing_small_tutorial:
		hide_small_tutorial()
		return
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	if is_paused:
		unpause_game()
	else:
		pause_game()

func pause_game():
	is_paused = true
	main_game.get_tree().paused = true
	pause_menu.show()
	AudioManager.pause.play()

func unpause_game():
	is_paused = false
	main_game.get_tree().paused = false
	pause_menu.hide()
	AudioManager.pause.play()

func on_level_up(level: int) -> void:
	is_paused = true
	main_game.get_tree().paused = true
	self.on_powerup_menu = true
	self.powerup_menu.create_upgrade_menu()

func _on_resume_pressed() -> void:
	unpause_game()

func _on_credits_pressed() -> void:
	pause_menu.hide()
	self.show_credits()
	
func _on_restart_pressed() -> void:
	unpause_game()
	Global.reset_game()
	SceneManager.reload_scene({
		"pattern_enter": "squares",
		"pattern_leave": "squares",
	})

func show_big_tutorial() -> void:
	await get_tree().create_timer(2).timeout
	AudioManager.pause.play()
	big_tutorial.show_tutorial()
	showing_big_tutorial = true
	main_game.get_tree().paused = true

func hide_big_tutorial() -> void:
	big_tutorial.finish()
	showing_big_tutorial = false
	main_game.get_tree().paused = false
	main_game.enemy_manager.start_this_shit()

func show_small_tutorial() -> void:
	await get_tree().create_timer(2).timeout
	AudioManager.pause.play()
	small_tutorial.show_tutorial()
	showing_small_tutorial = true
	main_game.get_tree().paused = true
	
func hide_small_tutorial() -> void:
	small_tutorial.finish()
	showing_small_tutorial = false
	self.tutorial_ended = true
	main_game.get_tree().paused = false

func show_credits() -> void:
	main_game.hud.hide()
	main_game.get_tree().paused = true
	credits.show_credits()
	
