class_name Player extends CharacterBody2D

@onready var animation_manager: AnimationManager = $AnimationManager
@onready var gun: Gun360 = $Gun360
@onready var movement_2d: Movement2D = $Movement2D
@onready var hurtbox: Hurtbox2D = $Hurtbox2D
@onready var hurtbox_big: CollisionShape2D = $Hurtbox2D/Big
@onready var hurtbox_small: CollisionShape2D = $Hurtbox2D/Small
@onready var invincibility_timer: Timer = $InvicibilityTimer
@onready var xp_collector: Area2D = $XpCollector
@onready var xp_magnet_shape: CircleShape2D = $XpMagnet/CollisionShape2D.shape
@onready var text_box: TextBox = $TextBox
@onready var transition_animation: AnimatedSprite2D = $TransitionAnimation
@onready var dash_timer: Timer = $DashTimer
@onready var dash_cooldown: Timer = $DashCooldown
@onready var dash_progress: ProgressBar = $DashProgress
@onready var dash_indicator: Sprite2D = $DashIndicator
@onready var dash_animation: AnimatedSprite2D = $DashAnimation
@onready var player_control_2d: PlayerControl2D = $PlayerControl2D
@onready var camera_shake: ShakerComponent2D = $Camera/ShakerComponent2D
@onready var camera: Camera2 = $Camera

var dash_time: float = 1.5
var first_time_big: bool = true
var first_time_small: bool = true
var is_dead: bool = false

@export var SMALL_BASE_SPEED: int = 400:
	set(value):
		SMALL_BASE_SPEED = value
		movement_2d.curr_max_speed = SMALL_BASE_SPEED if curr_state == Global.State.SMALL else BIG_BASE_SPEED
@export var BIG_BASE_SPEED: int = 300:
	set(value):
		BIG_BASE_SPEED = value
		movement_2d.curr_max_speed = SMALL_BASE_SPEED if curr_state == Global.State.SMALL else BIG_BASE_SPEED

var level: int = 1:
	set(value):
		level = value
		max_xp = int(value * value * value / 1.5 + 20 * value)
var curr_xp: int = 0:
	set(value):
		Global.xp_changed.emit(self.level, value, self.max_xp)
		curr_xp = value
var max_xp: int = 10

var curr_state: Global.State:
	set(value):
		if self.is_dead:
			return
		if value == curr_state:
			return
		curr_state = value
		@warning_ignore("standalone_ternary")
		gun.disable() if value == Global.State.SMALL else gun.enable()
		hurtbox_big.disabled = value == Global.State.SMALL
		hurtbox_small.disabled = value == Global.State.BIG
		animation_manager.switch_state(value)
		$XpMagnet/CollisionShape2D.disabled = value == Global.State.BIG
		movement_2d.curr_max_speed = SMALL_BASE_SPEED if value == Global.State.SMALL else BIG_BASE_SPEED
	
var dash_speed: float

func _ready() -> void:
	self.curr_state = Global.State.SMALL
	PolarTimer.timeout.connect(self.on_polar_timer_timeout)
	Global.gained_powerup.connect(self._on_gained_powerup)
	Global.player = self
	
func _process(_delta: float) -> void:
	if self.is_dead:
		return
	
	if not dash_timer.is_stopped():
		self.dash_progress.value = self.dash_time - self.dash_timer.time_left
	
	if self.curr_state == Global.State.SMALL and self.dash_cooldown.is_stopped():
		dash_indicator.show()
	else:
		dash_indicator.hide()
		
	
	if self.curr_xp >= self.max_xp:
		self.level_up()
	
	if self.animation_manager:
		if self.global_position.x < get_global_mouse_position().x:
			self.animation_manager.flip_h = false
		elif self.global_position.x > get_global_mouse_position().x:
			self.animation_manager.flip_h = true
	
	if Input.is_action_just_pressed("dash"):
		self.dash()
		
	if Input.is_action_just_pressed("stop") and OS.is_debug_build():
		self.switch_state()
		PolarTimer.start()

func dash() -> void:
	if self.curr_state != Global.State.SMALL:
		return
	
	if not self.dash_cooldown.is_stopped():
		return
	
	dash_speed = self.movement_2d.curr_max_speed * 0.25
	self.movement_2d.curr_max_speed += dash_speed
	
	AudioManager.player_dash.play()
	self.hurtbox_small.disabled = true
	animation_manager.dim_small()
	dash_cooldown.start()
	dash_timer.start(dash_time)
	dash_animation.play("default")
	dash_progress.value = 0
	dash_progress.max_value = dash_time
	dash_progress.show()

func on_polar_timer_timeout() -> void:
	self.switch_state()

func switch_state() -> void:
	transition_animation.play()
	AudioManager.player_transform.play()

	if self.curr_state == Global.State.SMALL:
		if self.first_time_big:
			self.first_time_big = false
			Global.game_root.main_game.hud.show_hud()
			Global.first_time_big_signal.emit()
		self.curr_state = Global.State.BIG
		self.dash_progress.hide()
		AudioManager.player_transform_big.play()
	else:
		if self.first_time_small:
			self.first_time_small = false
			Global.first_time_small_signal.emit()
		self.curr_state = Global.State.SMALL
		AudioManager.player_transform_small.play()
	
	if Global.show_bear_text:
			text_box.show_random_by_state(self.curr_state)

func _on_hurtbox_2d_hurt_signal() -> void:
	if self.is_dead:
		return
	#self.hurtbox_small.disabled = true
	#self.hurtbox_big.disabled = true
	AudioManager.player_hurt.play()
	self.camera_shake.play_shake()
	
	#self.invincibility_timer.start()
	sprite_flash()

func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(self.animation_manager, "modulate:r", 1, 0.25).from(15)

func _on_invicibility_timer_timeout() -> void:
	if not dash_timer.is_stopped():
		return
	self.hurtbox_small.disabled = self.curr_state != Global.State.SMALL
	self.hurtbox_big.disabled = self.curr_state != Global.State.BIG


func _on_xp_collector_area_entered(area: Area2D) -> void:
	if not area.is_in_group("xp_gem") and not area.is_in_group("food"):
		return
	
	if area.is_in_group("xp_gem"):
		
		var sound: SoundDirect = SoundDirect.new()
		add_child(sound)
		sound.play_sound(AudioManager.xp_pickup.stream, "SFX")
		
		self.add_xp(area.get_parent().xp)
	else:
		self.hurtbox.heal(area.get_parent().hp)
		
	area.get_parent().queue_free()
	

func add_xp(collected_xp: int) -> void:
	self.curr_xp += collected_xp
	
	if (self.curr_xp < self.max_xp):
		#AudioManager.xp_pickup.play()
		return
		
	self.level_up()

func level_up() -> void:
	if not Global.game_root.tutorial_ended:
		return
	if self.curr_xp < self.max_xp:
		return
	
	self.curr_xp -= self.max_xp
	self.level += 1
	AudioManager.level_up.play()
	Global.game_root.on_level_up(self.level)
	
func _on_gained_powerup() -> void:
	if self.curr_xp < self.max_xp:
		return
	self.level_up()

func _on_xp_magnet_area_entered(area: Area2D) -> void:
	if not area.is_in_group("xp_gem") and not area.is_in_group("food"):
		return

	var collectable = area.get_parent()
	collectable.move = self.xp_collector


func _on_xp_magnet_area_exited(area: Area2D) -> void:
	if not area.is_in_group("xp_gem") and not area.is_in_group("food"):
		return
		
	var xp_gem = area.get_parent()
	xp_gem.move = null


func _on_dash_timer_timeout() -> void:
	if curr_state == Global.State.SMALL:
		self.movement_2d.curr_max_speed -= dash_speed
	self.dash_progress.hide()
	self.animation_manager.undim_small()
	self.hurtbox_small.disabled = self.curr_state != Global.State.SMALL
	self.hurtbox_big.disabled = self.curr_state != Global.State.BIG


func _on_hurtbox_2d_death_signal() -> void:
	if self.is_dead:
		return
	self.is_dead = true
	transition_animation.play()
	animation_manager.hide()
	self.gun.queue_free()
	AudioManager.gameover.play()
	self.movement_2d.queue_free()
	self.hurtbox_small.disabled = true
	self.hurtbox_big.disabled = true
	
	self.player_control_2d.queue_free()
	self.velocity = Vector2.ZERO
	self.move_and_slide()
	
	await get_tree().create_timer(2).timeout
	Global.game_root.show_credits()


func _on_hurtbox_2d_heal_signal() -> void:
	AudioManager.hp_pickup.play()
