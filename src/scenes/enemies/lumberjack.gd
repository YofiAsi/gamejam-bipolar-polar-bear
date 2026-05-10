extends CharacterBody2D

@onready var movement2d: Movement2D = $Movement2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_collision: CollisionShape2D = $HitBox/CollisionShape2D
#@onready var visible_notifier: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

@export var dmg: int = 10
@export var xp_drop: int = 5

var dead: bool = false

func _ready() -> void:
	animated_sprite.play("run")

func _process(delta: float) -> void:
	if self.dead:
		return
	if not movement2d:
		return
	
	movement2d.move_direction(self.global_position.direction_to(Global.player.global_position))
	self.animated_sprite.flip_h = movement2d.direction.x < 0

func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(animated_sprite, "modulate:r", 1, 0.25).from(15)

func _on_hurtbox_2d_hurt_signal() -> void:
	self.sprite_flash()

func _on_hurtbox_2d_death_signal() -> void:
	self.animated_sprite.play("death")
	self.dead = true
	self.hitbox_collision.disabled = true
	
	movement2d.curr_state = movement2d.State.DEAD
	var splash_direction: Vector2 = - self.global_position.direction_to(Global.player.global_position)
	Global.xp_spawner.generate_gems(self.xp_drop, self.global_position + splash_direction.normalized() * 50, splash_direction.normalized())
	if randi() % 100 <= 1:
		Global.xp_spawner.generate_food(self.global_position + splash_direction.normalized() * 50, splash_direction.normalized())
	$DeathQueueTimer.start()

func _on_death_queue_timer_timeout() -> void:
	self.queue_free()


func _on_hit_box_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player"):
		return
	
	var player_hurtbox: Hurtbox2D = area
	player_hurtbox.hurt(self.dmg)
