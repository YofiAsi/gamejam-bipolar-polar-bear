class_name GameManager extends Node2D

@onready var hud: GameHUD = $HUD
@onready var winning_timer: WinningTimer = $WinningTimer
@onready var enemy_manager: EnemyManager = $EnemyManager

func _ready() -> void:
	Global.tutorial()
	AudioManager.pre_song.stop()
	if not AudioManager.main_song.playing:
		AudioManager.main_song.play()
