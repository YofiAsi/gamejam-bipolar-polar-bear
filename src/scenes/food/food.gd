class_name Food extends CharacterBody2D

@export var sprites: Array

var move: Node2D
var speed: float = 300
var deceleration: float = 2000
var hp: int = 30

func _ready() -> void:
	$Sprite2D.texture = sprites.pick_random()

func _process(delta: float) -> void:
	if move:
		# Accelerate toward the target
		var direction = self.global_position.direction_to(move.global_position).normalized()
		velocity = direction * speed
	else:
		# Decelerate if no target
		if velocity.length() > 0:
			velocity = velocity.normalized() * max(0, velocity.length() - deceleration * delta)

	# Apply velocity to move the gem
	self.move_and_slide()
