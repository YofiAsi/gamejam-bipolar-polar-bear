class_name Tutoraial extends CanvasLayer

func _ready() -> void:
	self.hide()

func show_tutorial() -> void:
	self.show()

func finish() -> void:
	self.queue_free()
