class_name XpGem extends CharacterBody2D

var move: Node2D
var speed: float = 1200
var deceleration: float = 2000
#var velocity: Vector2 = Vector2.ZERO
var xp: int = 5

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
