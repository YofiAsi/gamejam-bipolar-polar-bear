class_name WinningTimer extends CanvasLayer

@onready var timer: Timer = $Timer
@onready var timer_label: Label = $Label

signal tick(time_passed: int)

var remaining_time: int = 20 * 60  # 20 minutes in seconds
var time_passed: int = 0

func _ready() -> void:
	update_timer_label()
	self.hide()
	timer.timeout.connect(on_timer_timeout)

func start() -> void:
	timer.start()

func stop() -> void:
	timer.stop()

func on_timer_timeout() -> void:
	if remaining_time > 0:
		remaining_time -= 1
		time_passed += 1
		update_timer_label()
		tick.emit(self.time_passed)
	else:
		timer.stop()
		timer_label.text = "YOU WON!"
		Global.won = true
		Global.game_root

func update_timer_label() -> void:
	var minutes = remaining_time / 60
	var seconds = remaining_time % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]
