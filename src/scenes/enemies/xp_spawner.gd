class_name XpSpawner extends Node2D

const XP_GEM: PackedScene = preload("res://src/scenes/xp_gem/xp_gem.tscn")
const FOOD: PackedScene = preload("res://src/scenes/food/food.tscn")

func _ready() -> void:
	Global.xp_spawner = self

func generate_food(init_position: Vector2, direction: Vector2) -> void:
	var food = FOOD.instantiate()
	food.position = init_position

	# Randomize the spread in the direction vector
	var spread_angle = randf_range(-PI / 12, PI / 12)  # Spread within +/- 30 degrees
	var spread_direction = direction.rotated(spread_angle).normalized()

	# Random initial speed for splash effect
	var speed = randf_range(1.3, 1.8) * 500 + 100  # Random initial speed between 100 and 300
	var velocity = spread_direction * speed

	# Set the velocity in the gem
	food.velocity = velocity

	self.get_parent().add_child(food)

func generate_gems(xp: int, init_position: Vector2, direction: Vector2) -> void:
	var gem_amount = int(xp / 3)
	while (xp > 0):
		var xp_gem = XP_GEM.instantiate()
		xp_gem.position = init_position

		# Randomize the spread in the direction vector
		var spread_angle = randf_range(-PI / 12, PI / 12)  # Spread within +/- 30 degrees
		var spread_direction = direction.rotated(spread_angle).normalized()

		# Random initial speed for splash effect
		var speed = randf_range(1.3, 1.8) * 500 + 100  # Random initial speed between 100 and 300
		var velocity = spread_direction * speed

		# Set the velocity in the gem
		xp_gem.velocity = velocity

		xp_gem.xp = gem_amount
		xp -= xp_gem.xp
		self.add_child(xp_gem)
