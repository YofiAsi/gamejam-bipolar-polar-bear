class_name Camera2 extends Camera2D

@onready var shaker_component: ShakerComponent2D = $ShakerComponent2D

@export var FOLLOW_DAMPING: float = 0.5
@export var MOUSE_MOVEMENT_SPEED: float = 500.
@export var MAX_MOUSE_MOVEMENT: float = 100.
@export var follow_node: Array[Node2D]
@export var allow_mouse_follow: bool = true
@export var shake_noise: PhantomCameraNoise2D

func _ready() -> void:
	Global.gun_shot_signal.connect(self.on_gun_shot_signal)
	
func _process(delta: float) -> void:
	if allow_mouse_follow:
		var screen_size = get_viewport_rect().size
		var mouse_position = get_viewport().get_mouse_position()
		var max_screen_distance = screen_size.distance_to(Vector2.ZERO)
		var follow_offset = (mouse_position - (screen_size / 2.)) * MOUSE_MOVEMENT_SPEED / max_screen_distance
		follow_offset = follow_offset.limit_length(MAX_MOUSE_MOVEMENT)
		self.offset = follow_offset
	
func on_gun_shot_signal() -> void:
	shaker_component.play_shake()
