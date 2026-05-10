extends Node2D

var timer: Timer = Timer.new()

func _ready() -> void:
	timer.wait_time = 1
	timer.autostart = true
	timer.one_shot = false
	timer.timeout.connect(func(): print(get_viewport()))
	add_child(timer)
	timer.start()
