class_name Credits extends CanvasLayer

@onready var title: Label = $Label
@onready var sub_title: Label = $Label2

func show_credits() -> void:
	title.text = "Game Over!" if not Global.won else "You Won !!!"
	sub_title.text = "try doing better next time" if not Global.won else "Thank you for playing <3"
	self.show()
	

func _on_play_pressed() -> void:
	Global.game_root._on_restart_pressed()

func _on_main_menu_mouse_entered() -> void:
	AudioManager.button_hover.play()
