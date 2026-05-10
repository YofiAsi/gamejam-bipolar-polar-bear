extends Node

@onready var gun_shoot: AudioStreamPlayer = $SFX/Player/GunShoot
@onready var gun_reload: AudioStreamPlayer = $SFX/Player/GunReload
@onready var hp_pickup: AudioStreamPlayer = $SFX/Player/HpPickup
@onready var level_up: AudioStreamPlayer = $SFX/Player/LevelUp
@onready var xp_pickup: AudioStreamPlayer = $SFX/Player/XpPickup
@onready var player_dash: AudioStreamPlayer = $SFX/Player/PlayerDash
@onready var player_transform: AudioStreamPlayer = $SFX/Player/PlayerTransform
@onready var enemy_hit: AudioStreamPlayer = $SFX/Enemy/EnemyHit
@onready var gameover: AudioStreamPlayer = $SFX/Game/GameOver
@onready var button_hover: AudioStreamPlayer = $SFX/Game/ButtonHover
@onready var button_press: AudioStreamPlayer = $SFX/Game/ButtonPress
@onready var pause: AudioStreamPlayer = $SFX/Game/Pause
@onready var pre_song: AudioStreamPlayer = $Music/PreSong
@onready var main_song: AudioStreamPlayer = $Music/MainSong
@onready var player_transform_big: AudioStreamPlayer = $SFX/Player/PlayerTransformBIG
@onready var player_transform_small: AudioStreamPlayer = $SFX/Player/PlayerTransformSMALL
@onready var player_hurt: AudioStreamPlayer = $SFX/Player/PlayerHurt

func play_intro() -> void:
	main_song.stop()
	pre_song.play()

func play_main_theme() -> void:
	if main_song.playing:
		return
	main_song.play()
	pre_song.stop()
