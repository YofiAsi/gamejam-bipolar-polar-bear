class_name AnimationManager extends Node2D

@onready var big_sprite: AnimatedSprite2D = $BigAnimatedSprite
@onready var small_sprite: AnimatedSprite2D = $SmallAnimatedSprite
		
var flip_h: bool:
	set(value):
		big_sprite.flip_h = value
		small_sprite.flip_h = value
		flip_h = value

func _ready() -> void:
	big_sprite.hide()
	small_sprite.show()

func play(name: StringName = &"", custom_speed: float = 1.0, from_end: bool = false) -> void:
	big_sprite.play(name, custom_speed, from_end)
	small_sprite.play(name, custom_speed, from_end)
	

func dim_small() -> void:
	small_sprite.modulate = Color(1, 1, 1, 0.2)  # Adjust the alpha to 0.5 for transparency

func undim_small() -> void:
	small_sprite.modulate = Color(1, 1, 1, 1)  # Adjust the alpha to 0.5 for transparency

func switch_state(target_state: Global.State):
	if target_state == Global.State.SMALL:
		big_sprite.hide()
		small_sprite.show()
	else:
		big_sprite.show()
		small_sprite.hide()
