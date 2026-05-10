extends CanvasLayer

@onready var music: HSlider = $Control/VBoxContainer/Music
@onready var sfx: HSlider = $Control/VBoxContainer/SFX

func _ready():
	# Configure the sliders to match the volume range (-30 to 6 dB)
	music.min_value = -30
	music.max_value = 6
	music.value = clamp(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("music")), -30, 6)
	
	sfx.min_value = -30
	sfx.max_value = 6
	sfx.value = clamp(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")), -30, 6)
	
	$Control/VBoxContainer/CheckButton.button_pressed = Global.show_bear_text

func _on_music_value_changed(value: float) -> void:
	if value <= music.min_value:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), -80)  # -inf in dB to mute
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), value)

func _on_sfx_value_changed(value: float) -> void:
	if value <= sfx.min_value:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -80)  # -inf in dB to mute
	else:
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)


func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.show_bear_text = toggled_on


func _on_visibility_changed() -> void:
	music.value = clamp(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("music")), -30, 6)
	sfx.value = clamp(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")), -30, 6)
