extends Node2D

@onready var player: Player = $Player
@onready var hp_label: Label = $CanvasLayer/VBoxContainer/VBoxContainer/HpLabel
@onready var regen_label: Label = $CanvasLayer/VBoxContainer2/VBoxContainer2/RegenLabel
@onready var dmg_label: Label = $CanvasLayer/VBoxContainer2/VBoxContainer3/DmgLabel
@onready var dmg_slider: HSlider = $CanvasLayer/VBoxContainer2/DmgSlider
@onready var regen_slider: HSlider = $CanvasLayer/VBoxContainer2/RegenSlider

func _ready() -> void:
	hp_label.text = str(player.hurtbox.curr_hp)
	regen_label.text = str(player.hurtbox.health_regen)
	

func _process(delta: float) -> void:
	hp_label.text = str(player.hurtbox.curr_hp)

func _on_button_pressed() -> void:
	player.hurtbox.hurt(int(dmg_slider.value))


func _on_regen_slider_value_changed(value: float) -> void:
	player.hurtbox.health_regen = value
	regen_label.text = str(value)


func _on_dmg_slider_value_changed(value: float) -> void:
	dmg_label.text = str(value)
