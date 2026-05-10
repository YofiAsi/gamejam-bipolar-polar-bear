extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var movement2d: Movement2D = $Movement2D
@export var xp_drop: int = 5

var dead: bool = false

func _ready() -> void:
	animated_sprite.play("idle")
	animated_sprite.flip_h = randi() % 10 < 5

func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(animated_sprite, "modulate:r", 1, 0.25).from(15)

func _on_hurtbox_2d_hurt_signal() -> void:
	self.sprite_flash()

func _on_hurtbox_2d_death_signal() -> void:
	self.animated_sprite.play("death")
	self.dead = true
	
	var splash_direction: Vector2 = - self.global_position.direction_to(Global.player.global_position)
	Global.xp_spawner.generate_gems(self.xp_drop, self.global_position + splash_direction.normalized() * 50, splash_direction.normalized())
	if randi() % 100 < 5:
		Global.xp_spawner.generate_food(self.global_position + splash_direction.normalized() * 50, splash_direction.normalized())
	$DeathQueueTimer.start()

func _on_death_queue_timer_timeout() -> void:
	self.queue_free()
